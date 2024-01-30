#!/bin/bash

# root 用户下执行

# 设置密码验证为允许
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

# 添加末尾的内容
sudo tee -a /etc/ssh/sshd_config <<EOF
PermitRootLogin yes
PubkeyAuthentication yes
TCPKeepAlive yes
ClientAliveInterval 60
ClientAliveCountMax 600
EOF

# 创建 proxy.conf
sudo cat >".ssh/authorized_keys" <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5AKSY8s8J5gq+XRhN46ccIBKt9TSk4XC+1o+UjwzPt MacBot
EOF

# 重新加载 SSH 配置
sudo systemctl reload sshd
sudo apt update -y
sudo apt upgrade -y
sudo apt install build-essential zsh screen zip unzip wget git vim net-tools universal-ctags apt-transport-https ca-certificates curl software-properties-common -y
sudo apt install gcc-11-locales debian-keyring autoconf automake libtool flex bison gdb bzr libgd-tools -y

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

bash <(wget -qO- --no-check-certificate https://gitlab.com/spiritysdx/Oracle-server-keep-alive-script/-/raw/main/oalive.sh)

# touch ~/.hushlogin # 使用clean_login_log.sh

# 安装rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 初始化 mysql
# mysql_secure_installation
# "
## ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Rain@8240';
## FLUSH PRIVILEGES;
# UPDATE USER SET HOST='%' WHERE USER='root';
# SHOW variables LIKE 'validate%';
# SET GLOBAL validate_password.length = 4;
# SET GLOBAL validate_password.policy = LOW;
# ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'rain8240';
# FLUSH PRIVILEGES;
# "

curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs

# 安装 golang
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt-get update
sudo apt-get install golang-go

### vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

### 安装 php
apt install php-fpm -y
