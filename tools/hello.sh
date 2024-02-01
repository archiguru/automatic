#!/bin/bash
#****************************************#
# Author: 张向阳
# Created Time :2024-01-29 15:22
# File Name: /etc/profile.d/hello.sh
# Description:
#****************************************#
# 根据计算机当前时间,返回问候语,可以将该脚本设置为开机启动
JSON=$(curl -s "https://api.seniverse.com/v3/weather/now.json?key=SF9EwloXKHhll2ZcX&location=hangzhou&language=zh-Hans&unit=c")
# 使用 jq 提取所需信息并输出
CURRENT_WEATHER=$(echo "$JSON" | jq -r '.results[0].location.name, .results[0].now.text, .results[0].now.temperature' | tr -d '\n')

tm=$(date +%H)
if [ $tm -le 12 ]; then
    msg="🌞  早上好！ $USER"
elif [ $tm -gt 12 -a $tm -le 18 ]; then
    msg="🌈  下午好！ $USER"
else
    msg="🌛  晚上好！ $USER"
fi
echo "  * * * * * * * * * * * * * * * * * * * * * * *"
echo "  *      现在时间是:$(date +"%Y‐%m‐%d %H:%M:%S") "
echo -e "  *     \033[34m       $msg\033[0m "
echo "  *          当前${CURRENT_WEATHER[0]}${CURRENT_WEATHER[1]}，温度${CURRENT_WEATHER[2]}度 "
echo "  * * * * * * * * * * * * * * * * * * * * * * *"
