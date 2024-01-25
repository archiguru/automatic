#!/bin/bash
cp /etc/apt/sources.list /etc/apt/sources.list.bak
# Ubuntu 源
sudo sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo sed -i 's/http:/https:/g' /etc/apt/sources.list
sudo apt-get update -y
sudo apt install -y apt-transport-https zsh screen zip unzip wget curl git
