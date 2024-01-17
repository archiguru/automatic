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


