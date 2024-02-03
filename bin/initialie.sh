#!/bin/bash
#****************************************
# Author: ArchiGuru
# Created Time :2024-01-30 16:34
# File Name: initialie.sh
# Description: 
#****************************************

# 定义全局变量 git_url

git_url=""

choose_platform() {
    echo "请选择使用的代码托管平台："
    echo "1. GitHub"
    echo "2. Gitee"

    read -p "请输入选项的数字编号：" choice
    case $choice in
    1) git_url="git@github.com" ;;
    2) git_url="git@gitee.com" ;;
    *) echo "无效的选项，请重新选择" && choose_platform ;;
    esac
}

choose_platform

if [[ "$git_url" != "git@github.com" && "$git_url" != "git@gitee.com" ]]; then
    echo "Git URL无效。退出脚本。"
    exit 1
fi

echo "您选择的平台是：$git_url"

gh_user="archiguru"
gh_repo="archiguru"

if [ "$(uname)" == "Darwin" ]; then
    repo=$(pwd)
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    repo="/data/GitHub/$gh_repo/"
fi

cd $repo || exit

git remote -v
rm -rf .git
git init
#git branch -m "main"
git remote add origin $git_url:$gh_user/$gh_repo.git
git add -A && git commit -m "first commit"
git push -u origin main --force
exit 0
