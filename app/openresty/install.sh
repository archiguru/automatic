#!/bin/bash
#****************************************
# Author: ArchiGuru
# Created Time :2024-01-30 16:34
# File Name: nginx_install.sh
# Description:
#****************************************

set -e

# 设置全局变量
SCRIPT_DIR="/root/nginx"
SRC_DIR="/data/src"
WEB_DIR="/var/www"
NGINX_GROUP="nginx"
NGINX_USER="nginx"
OPENSSL111_VERSION="1.1.1w"
PCRE_VERSION="8.45"
ZLIB_VERSION="1.3.1"
THREADS=$(grep -c ^processor /proc/cpuinfo)
OPENRESTY_VERSION=$(curl -s https://openresty.org/cn/download.html | grep -oP 'openresty-\K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
INSTALL_DIR="${SRC_DIR}/openresty-${OPENRESTY_VERSION}"

# 清理旧文件
cleanup() {
    echo "******************    清理旧文件...     *************"
    # 使用全局变量
    if [ -d "${INSTALL_DIR}" ]; then
        cd "${INSTALL_DIR}"
        make clean || true
        echo "清理成功，make clean 完成"
    else
        echo "安装目录不存在，无需清理。"
    fi
    if systemctl is-active --quiet nginx.service; then
        systemctl stop nginx.service || true
    fi
    cd ${HOME} || true
    sudo rm -rf "${INSTALL_DIR}" "${SRC_DIR}/openssl-${OPENSSL111_VERSION}" "${SRC_DIR}/pcre-${PCRE_VERSION}" "${SRC_DIR}/zlib-${ZLIB_VERSION}"
    if [ -f "/lib/systemd/system/nginx.service" ]; then
        systemctl disable nginx.service
    fi
    systemctl daemon-reload
    if id "$NGINX_USER" &>/dev/null; then
        sudo userdel "$NGINX_USER" || true # 删除 nginx 用户，忽略可能出现的错误
    else
        echo "用户 $NGINX_USER 不存在。跳过用户删除。"
    fi

    if grep -q "^${NGINX_GROUP}:" /etc/group; then
        sudo groupdel "$NGINX_GROUP" || true # 删除 nginx 用户组，忽略可能出现的错误
    else
        echo "用户组 $NGINX_GROUP 不存在。跳过用户组删除。"
    fi
    echo "******************    清理完成 ✅       *************"
}

# 错误处理
error_handler() {
    echo "发生错误，请检查日志文件以获取更多信息，清理临时文件"
    cleanup
}

trap error_handler ERR

# 终止占用锁文件的进程
terminate_apt_process() {
    sudo rm -f /var/lib/apt/lists/lock /var/cache/apt/archives/lock /var/lib/dpkg/lock* || true
    sudo dpkg --configure -a
}

# 预检查
pre_check() {
    terminate_apt_process
    if ! sudo apt update -y; then
        echo "apt 更新失败。"
        exit 1
    fi
    sudo apt install build-essential libpcre3 libperl-dev libpcre3-dev zlib1g zlib1g-dev libssl-dev libgeoip-dev luajit libxslt1-dev libgd-dev libreadline-dev libncurses5-dev libncursesw5-dev libmaxminddb0 libmaxminddb-dev mmdb-bin libbrotli-dev -y
    sudo mkdir -p "${SRC_DIR}" /var/www/ /var/cache/nginx/
    sudo touch /etc/logrotate.d/nginx
}

# 创建用户和用户组
create_user_group() {
    sudo groupadd -f ${NGINX_GROUP}
    id -u ${NGINX_USER} &>/dev/null || sudo useradd -r -g ${NGINX_GROUP} -s /sbin/nologin -d /usr/local/nginx -c "OpenResty nginx web server" ${NGINX_USER}
}

# 下载文件
download_file() {
    cd ${SRC_DIR} || exit
    local url=$1
    local file_dir=$2
    local filename=$(basename "$url")
    if [ ! -f "$filename" ]; then
        echo "文件 $filename 不存在，开始下载..."
        curl -O "$url" || wget "$url"
    fi
    rm -rf "$file_dir"
    tar xzf "$filename"
    cd -
}

# 通用函数：下载源码
download_source() {
    cd ${SRC_DIR} || exit
    # 下载 OpenResty 源码
    openresty_url="https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz"
    download_file "$openresty_url" "openresty-${OPENRESTY_VERSION}"
    # 下载 OpenSSL 源码
    openssl_url="https://www.openssl.org/source/openssl-${OPENSSL111_VERSION}.tar.gz"
    download_file "$openssl_url" "openssl-${OPENSSL111_VERSION}"
    # 下载 PCRE 源码
    pcre_url="https://ftp.exim.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz"
    download_file "$pcre_url" "pcre-${PCRE_VERSION}"
    # 下载 zlib 源码
    zlib_url="https://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz"
    download_file "$zlib_url" "zlib-${ZLIB_VERSION}"
    # 下载 NJS 源码
    njs_url="https://hg.nginx.org/njs/archive/tip.tar.gz"
    download_file "$njs_url" "njs"
    mv -f njs* njs
    mv -f njs openresty-${OPENRESTY_VERSION}/bundle/
}

# 安装 OpenResty
install_openresty() {
    if ! cd "${INSTALL_DIR}"; then
        echo "进入目录 OpenResty 源码目录失败。"
        exit 1
    fi
    # 配置
    configure_openresty
    # 编译并安装
    echo "*******************     开始编译     **********************"
    make -j "$THREADS"
    echo "*******************     开始安装     **********************"
    make install
    make clean
    # 添加启动项管理
    create_systemd_service
    # 备份配置
    echo "*******************     备份文件     **********************"
    sudo mkdir -p /etc/nginx/bak
    mv /etc/nginx/nginx.conf /etc/nginx/bak/nginx.conf.bak
    # 下载新的配置文件
    echo "*******************     使用新的配置文件     **********************"
    wget -O /etc/nginx/nginx.conf https://gitee.com/archiguru/automatic/raw/main/app/openresty/nginx.conf

    echo "创建配置文件目录"
    mkdir -p /etc/nginx/conf.d/
    mkdir -p /etc/nginx/sites-available/
    mkdir -p /etc/nginx/sites-enabled/

    # 添加 proxy.conf 配置
    create_proxy_conf
    # 配置 logrotate
    configure_logrotate

    sudo mkdir -p /var/www/default
    wget -O /var/www/default/index.html https://gitee.com/archiguru/automatic/raw/main/app/openresty/index.html

    # 设置权限
    sudo chown -R ${NGINX_USER}:${NGINX_GROUP} /var/www/ /var/log/nginx/ /var/cache/nginx/ /etc/nginx/ /etc/logrotate.d/nginx /usr/local/nginx/ /usr/lib/nginx/
    # 重载配置
    ldconfig
    echo "*******************     启动 nginx 服务     **********************"
    systemctl daemon-reload
    systemctl start nginx.service
    systemctl enable nginx.service
    systemctl status nginx.service
}

# 配置 OpenResty
configure_openresty() {
    ./configure \
        --prefix=/usr/local/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/run/nginx.pid \
        --lock-path=/run/lock/nginx.lock \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=${NGINX_USER} \
        --group=${NGINX_GROUP} \
        --with-luajit \
        --with-pcre \
        --with-pcre=../pcre-${PCRE_VERSION} \
        --with-pcre-jit \
        --with-zlib=../zlib-${ZLIB_VERSION} \
        --with-openssl=../openssl-${OPENSSL111_VERSION} \
        --with-perl=/usr/bin/perl \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-http_xslt_module \
        --with-http_image_filter_module \
        --with-http_geoip_module=dynamic \
        --with-http_perl_module \
        --with-threads \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-stream_realip_module \
        --with-stream_geoip_module \
        --add-dynamic-module=./bundle/njs/nginx
}

# 创建 systemd 服务
create_systemd_service() {
    cat >/lib/systemd/system/nginx.service <<EOF
[Unit]
Description=nginx - high performance web server
Documentation=https://openresty.org/cn/installation.html
After=network.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPost=/bin/sleep 0.1
ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx.conf
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s QUIT \$MAINPID
TimeoutStartSec=120
LimitNOFILE=1000000
LimitNPROC=1000000
LimitCORE=1000000

[Install]
WantedBy=multi-user.target
EOF
}

# 创建 proxy.conf
create_proxy_conf() {
    cat >/etc/nginx/proxy.conf <<EOF
proxy_connect_timeout 300s;
proxy_send_timeout 900;
proxy_read_timeout 900;
proxy_buffer_size 32k;
proxy_buffers 4 64k;
proxy_busy_buffers_size 128k;
proxy_redirect off;
proxy_hide_header Vary;
proxy_set_header Accept-Encoding '';
proxy_set_header Referer \$http_referer;
proxy_set_header Cookie \$http_cookie;
proxy_set_header Host \$host;
proxy_set_header X-Real-IP \$remote_addr;
proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto \$scheme;
EOF
}

# 配置 logrotate
configure_logrotate() {
    cat >/etc/logrotate.d/nginx <<EOF
${WEB_DIR}/*nginx.log {
    daily
    rotate 5
    missingok
    dateext
    compress
    notifempty
    sharedscripts
    postrotate
        [ -e /run/nginx.pid ] && kill -USR1 \`cat /run/nginx.pid\`
    endscript
}
EOF
}

# 定义成功提示
success_message="



  _____ _    _  _____ _____ ______  _____ _____
 / ____| |  | |/ ____/ ____|  ____|/ ____/ ____|
| (___ | |  | | |   | |    | |__  | (___| (___
 \___ \| |  | | |   | |    |  __|  \___ \\___ \
 ____) | |__| | |___| |____| |____ ____) |___) |
|_____/ \____/ \_____\_____|______|_____/_____/



"

# 完成后提示
done_tips() {
    echo ""
    echo "#***********************   ✅ 安装完成     **************************"
    echo ""
    echo "/etc/nginx/       ----------   [ ‼️  ] Nginx 配置文件目录"
    echo "/var/www/         ----------   [ ‼️  ] 网站文件和内容存储目录"
    echo "/var/log/nginx/   ----------   [ ‼️  ] Nginx 日志文件目录"
    echo "/var/cache/nginx  ----------   Nginx 缓存文件目录"
    echo "/usr/local/nginx  ----------   Nginx 安装主目录"
    echo "/usr/lib/nginx    ----------   Nginx 附加库目录"
    echo "/usr/sbin/nginx   ----------   Nginx 可执行文件路径"
    echo "/run/nginx.pid    ----------   Nginx 运行时 PID 文件路径"
    echo "/run/lock/nginx.lock -------   Nginx 运行时锁文件路径"
    echo "/etc/logrotate.d/nginx -----   Nginx 日志轮转配置文件"
    echo "/lib/systemd/system/nginx.service ------ Nginx systemd 服务配置文件"
    echo ""
    echo "#*******************************************************************"
    echo ""
}

# 主安装函数
main() {
    echo "欢迎使用 OpenResty 安装脚本"
    echo "请选择操作："
    echo "1. 安装/重新安装"
    echo "2. 卸载"
    read -p "请输入选项（1/2）: " choice

    case $choice in
    1)
        echo "开始安装..."
        ;;
    2)
        echo "开始卸载..."
        cleanup
        terminate_apt_process
        sudo apt autoremove -y
        echo "OpenResty 卸载完成"
        exit 0
        ;;
    *)
        echo "无效的选项，请重新运行脚本并输入正确的选项。"
        exit 1
        ;;
    esac

    # 执行安装操作
    if command -v nginx &>/dev/null; then
        echo "Nginx 已安装，开始卸载..."
        cleanup
        terminate_apt_process
        sudo apt autoremove -y
        echo "Nginx 卸载完成"
    else
        echo "Nginx 未安装，无需清理"
    fi
    echo "预检查"
    pre_check
    create_user_group
    download_source
    install_openresty
    echo "$success_message"
    done_tips
    exit 0
}

# 执行主函数
main
