#!/bin/bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
# Ubuntu 源
sudo sed -i 's@//.*.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo sed -i 's/http:/https:/g' /etc/apt/sources.list
sudo apt-get update -y
sudo apt install zsh screen zip unzip wget git net-tools -y

touch .hushlogin

sh -c "$(curl -fsSL https://raw.gitmirror.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sed 's#-ohmyzsh/ohmyzsh#-mirrors/ohmyzsh#; s#github.com/\$#gitee.com/\$#')"

sudo apt install universal-ctags -y

sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y

# step 2: 安装GPG证书
#curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
# Step 3: 写入软件源信息
# 获取系统架构
#architecture=$(uname -m)

# 判断架构类型
#if [ "$architecture" == "arm64" ]; then
#	echo "System architecture: arm64"
#elif [ "$architecture" == "amd64" ]; then
#	echo "System architecture: amd64"
#else
#	echo "Unsupported architecture: $architecture"
#	exit 1
#fi

#sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
# Step 4: 更新并安装Docker-CE
#sudo apt-get -y update
# sudo apt-get -y install docker-ce
