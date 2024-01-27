#!/usr/bin/sh
### OpenResty 安装脚本

set -e

# 设置变量
set_variables() {
    # 脚本目录
    SCRIPT_DIR="/root/nginx"
    # 源码目录
    SRC_DIR="/data/src"
    # Web 目录
    WEB_DIR="/var/www"
    # 安装目录
    INSTALL_DIR="${SRC_DIR}/openresty-${OPENRESTY_VERSION}"
    # 用户和组
    NGINX_GROUP="nginx" # OpenResty 运行的组
    NGINX_USER="nginx"  # OpenResty 运行的用户
    # 版本
    OPENRESTY_VERSION="latest"
    OPENSSL111_VERSION="1.1.1w"
    PCRE_VERSION="8.45"
    ZLIB_VERSION="1.3.1"
    # 获取 CPU 线程数
    THREADS=$(grep -c ^processor /proc/cpuinfo)
    # 获取 OpenResty 版本号
    if [[ "$OPENRESTY_VERSION" = "latest" ]]; then
        local download_page=$(curl -s https://openresty.org/cn/download.html)
        OPENRESTY_VERSION=$(echo "$download_page" | tr -d '\n ' | grep '最新版' | grep -oP 'openresty-\K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
    fi
}

# 清理旧文件
cleanup() {
    echo "******************    清理旧文件...     *************"

    set_variables
    cd "${SRC_DIR}/openresty-${OPENRESTY_VERSION}" || exit
    systemctl stop nginx.service
    systemctl disable nginx.service
    cd "${SRC_DIR}" || exit
    sudo rm -rf openresty-${OPENRESTY_VERSION} openssl-${OPENSSL111_VERSION} pcre-${PCRE_VERSION} zlib-${ZLIB_VERSION}
    sudo rm -rf /var/www/default /var/log/nginx/default /var/cache/nginx /etc/nginx /etc/logrotate.d/nginx /usr/local/nginx /usr/lib/nginx /usr/sbin/nginx /run/nginx.pid /run/lock/nginx.lock /lib/systemd/system/nginx.service
    systemctl daemon-reload
    echo "******************    清理完成 ✅       *************"
}

trap cleanup ERR

# 预检查
pre_check() {
    set_variables

    # 使用 sudo 权限检查
    if ! sudo apt update -y; then
        echo "apt 更新失败。"
        exit 1
    fi

    # 安装依赖
    sudo apt install build-essential libpcre3 libperl-dev libpcre3-dev zlib1g zlib1g-dev libssl-dev libgeoip-dev luajit libxslt1-dev libgd-dev libreadline-dev libncurses5-dev libncursesw5-dev libmaxminddb0 libmaxminddb-dev mmdb-bin libbrotli-dev -y

    # 创建目录结构
    sudo mkdir -p "${SRC_DIR}" /var/www/ /var/cache/nginx/
    sudo touch /etc/logrotate.d/nginx
}

# 创建用户和用户组
create_user_group() {
    set_variables

    # 创建 nginx 用户组，如果不存在
    sudo groupadd -f ${NGINX_GROUP}
    # 创建 nginx 用户，如果不存在
    id -u ${NGINX_USER} &>/dev/null || sudo useradd -r -g ${NGINX_GROUP} -s /sbin/nologin -d /usr/local/nginx -c "OpenResty nginx web server" ${NGINX_USER}
}

# 下载文件
download_file() {
    set_variables
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
    set_variables
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
    set_variables

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
    make distclean

    # 添加启动项管理
    create_systemd_service

    # 备份配置
    echo "*******************     备份文件     **********************"
    sudo mkdir -p /etc/nginx/bak
    mv /etc/nginx/nginx.conf /etc/nginx/bak/nginx.conf.bak

    # 下载新的配置文件
    echo "*******************     使用新的配置文件     **********************"
    wget -O /etc/nginx/nginx.conf https://gitee.com/archiguru/automatic/raw/main/app/openresty/nginx.conf

    # 添加 proxy.conf 配置
    create_proxy_conf

    # 配置 logrotate
    configure_logrotate

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
    if command -v nginx &> /dev/null; then
        echo "Nginx 已安装，开始卸载..."
        cleanup
        sudo apt autoremove -y
        echo "Nginx 卸载完成"
    else
        echo "Nginx 未安装，无需清理"
    fi
    set_variables
    pre_check
    create_user_group
    download_source
    install_openresty
    done_tips
    exit 0
}

# 执行主函数
main
