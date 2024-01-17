#!/usr/bin/env bash
cd ~
# 前置检查
curl -fsSL https://gitee.com/jonnyhub/automatic/raw/master/include/check_os.sh > ./check_os.sh && chmod +x check_os.sh
. ~/check_os.sh
###############   可用变量   ###############
# 【包管理工具为】： ${PM}     如: apt
# 【系统类型为】： ${OS}       如: Debian
# 【系统 ID】 : ${OS_ID}      如: debian
# 【系统 code name】: ${OS_CNAME} 如:buster
###############   可用变量   ###############

tag=$(wget -qO- -t1 -T2 "https://api.github.com/repos/docker/compose/releases/latest" | jq -r '.tag_name')

latest_version=${tag: 1}

echo "【最新版本为】:  $latest_version"
sudo curl -L "https://github.91chi.fun//https://github.com//docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "安装完成！ 版本信息： "
docker-compose --version
echo "----------------------"

