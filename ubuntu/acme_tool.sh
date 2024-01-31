#!/bin/bash

# 默认邮箱地址
DEFAULT_EMAIL="jonny6015@163.com"

# DNSTencent API 密钥
export Tencent_SecretId="AKIDulX8cE77384uhMxa8cvJe1FKKHGFLPct"
export Tencent_SecretKey="RApZFqImDjR5jUQTOE1rmmgMzZ1dKByi"

# Nginx SSL 目录
NGINX_SSL_DIR="/etc/nginx/ssl"

# 安装 acme.sh
install_acme() {
    echo "正在安装 acme.sh..."
    read -p "请输入您的邮箱地址 [$DEFAULT_EMAIL]: " email
    email="${email:-$DEFAULT_EMAIL}"
    curl https://get.acme.sh | ACME_EMAIL=$email sh
    # echo "使用 systemd 管理："
    #     cat >"/etc/systemd/system/acme_letsencrypt.service" <<EOF
    # [Unit]
    # Description=Renew Let's Encrypt certificates using acme.sh
    # After=network-online.target

    # [Service]
    # Type=oneshot
    # # --home's argument should be where the acme.sh script resides.
    # ExecStart=/path/to/acme.sh --cron --home /path/to/acme.sh
    # EOF
    echo 'alias acme.sh="$HOME/.acme.sh/acme.sh"' >>~/.bashrc
    echo 'export PATH="$HOME/.acme.sh:$PATH"' >>~/.bashrc
    source ~/.bashrc
    echo "✅ acme.sh 安装完成，并已配置系统全局环境变量和别名。"
    # ~/.acme.sh/account.conf
}

# 升级 acme.sh
upgrade_acme() {
    echo "正在升级 acme.sh..."
    acme.sh --upgrade --auto-upgrade
    echo "✅ acme.sh 升级完成。"
}

# 申请证书
apply_certificate() {
    echo "切换「默认CA」 为 「Let’s Encrypt」..."
    acme.sh --set-default-ca --server letsencrypt
    echo "请输入您要申请的域名（多个域名以空格分隔，例如: example.com www.example.com）："
    read domains
    echo "正在申请证书..."
    retries=0
    max_retries=40
    wait_time=15
    while [ $retries -lt $max_retries ]; do
        # # acme.sh --issue --dns dns_tencent -d example.com -d *.example.com -d a.com --server https://acme.certcloud.cn/acme/directory
        acme.sh --issue --dns dns_tencent -d $(echo $domains | sed 's/ / -d /g') \
            --dnssleep $wait_time --keylength ec-256 \
            --server letsencrypt \
            --dns-dp $DP_Id,$DP_Key \
            --log "/path/to/mylog.log" \
            --auto-upgrade
        if [ $? -eq 0 ]; then
            echo "✅ 证书申请成功！"
            deploy_certificate $domains
            return 0
        else
            echo "❌ DNS验证失败，等待 $wait_time 秒后重新尝试..."
            sleep $wait_time
            retries=$((retries + 1))
        fi
    done
    echo "❌ 达到最大尝试次数，证书申请失败。"
}

# 部署证书到 Nginx
deploy_certificate() {
    local domains="$1"
    echo "正在部署证书到 Nginx..."
    acme.sh --install-cert -d $domains \
        --key-file $NGINX_SSL_DIR/$domains.key \
        --fullchain-file $NGINX_SSL_DIR/$domains.crt \
        --reloadcmd "service nginx force-reload"
    echo "✅ 证书部署完成。"
}

# 查询已申请的证书列表
list_certificates() {
    echo "已申请的证书列表："
    acme.sh --list
}

# 主菜单
main_menu() {
    echo "欢迎使用 acme.sh 脚本"
    echo "请选择操作："
    echo "1. 安装 acme.sh"
    echo "2. 升级 acme.sh"
    echo "3. 申请证书"
    echo "4. 查询已申请的证书"
    echo "q. 退出"
}

# 读取用户输入并执行对应操作
read_input() {
    read -p "请输入选项: " choice
    case "$choice" in
    1) install_acme ;;
    2) upgrade_acme ;;
    3) apply_certificate ;;
    4) list_certificates ;;
    q) echo "感谢使用，再见！" && exit ;;
    *) echo "❌ 无效选项，请重新输入。" && main_menu ;;
    esac
}

# 主程序
main() {
    while true; do
        main_menu
        read_input
    done
}

# 启动主程序
main
