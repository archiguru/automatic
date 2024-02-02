#!/bin/bash

### 以下内容手动安装
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# bash <(wget -qO- --no-check-certificate https://gitlab.com/spiritysdx/Oracle-server-keep-alive-script/-/raw/main/oalive.sh)
# 安装rust
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh && source "$HOME/.cargo/env"

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
