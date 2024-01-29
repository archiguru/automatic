#!/bin/bash

cd $HOME || exit

# 创建 hushlogin 隐藏文件
touch .hushlogin

# 备份源文件
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# Ubuntu 源
sudo sed -i 's@//.*.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo sed -i 's/http:/https:/g' /etc/apt/sources.list

sudo apt update -y

sudo apt upgrade -y

sudo apt install zsh screen zip unzip wget git vim net-tools universal-ctags apt-transport-https ca-certificates curl software-properties-common -y

sh -c "$(curl -fsSL https://raw.gitmirror.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sed 's#-ohmyzsh/ohmyzsh#-mirrors/ohmyzsh#; s#github.com/\$#gitee.com/\$#')"

sudo apt update -y
