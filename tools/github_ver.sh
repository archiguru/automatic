#!/bin/bash

echo "您输入的应用为： $1/$2"

# 发起 API 请求获取最新版本信息
response=$(curl -s https://api.github.com/repos/PCRE2Project/pcre2/releases)

echo $response
# 提取版本号
latest_version=$(echo "$response" | jq -r ".tag_name")

# 输出最新版本号
echo "最新版本号为: $latest_version"
