#!/bin/bash
cd ~
# 前置检查
curl -fsSL https://gitee.com/jonnyhub/automatic/raw/master/include/check_os.sh >./check_os.sh && chmod +x check_os.sh
. ~/check_os.sh
# install
${PM} update -y
${PM} upgrade -y
${PM} install -y wget gcc curl sudo screen ufw git zsh
