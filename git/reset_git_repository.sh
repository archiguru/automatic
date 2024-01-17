#!/bin/bash

# 检查是否安装了 git
if ! [ -x "$(command -v git)" ]; then
    echo "错误：git 未安装。" >&2
    exit 1
fi

# 提示用户风险并确认是否要操作
echo "警告：运行此脚本会永久删除历史提交记录、所有非 main 分支和所有 tag。请谨慎使用。"
echo "是否要继续？（y/n，默认为 n）："
read confirm

# 如果用户选择不继续，则退出脚本
if [ "$confirm" != "y" ]; then
    exit 0
fi

# 获取当前分支名称
current_branch=$(git rev-parse --abbrev-ref HEAD)

# 检查当前分支是否为 main
if [ "$current_branch" != "main" ]; then
    # 提示用户是否将当前分支作为 main 分支内容替换整个仓库
    echo "当前分支不是 main。是否将当前分支作为 main 分支内容替换整个仓库？（y/n，默认为 n）："
    read replace_main

    # 如果用户选择将当前分支作为 main 分支内容替换整个仓库，则进行替换操作
    if [ "$replace_main" == "y" ]; then
        # 检查本地仓库是否存在 main 分支，如果存在，则删除它
        if git show-ref --verify --quiet refs/heads/main; then
            git branch -D main
        fi

        # 检查远程仓库是否存在 main 分支，如果存在，则删除它
        if git ls-remote --heads origin main | grep main; then
            git push origin --delete main
        fi

        # 将当前分支重命名为 main 分支
        git branch -m $current_branch main
        current_branch="main"
    else
        exit 0
    fi
fi

# 删除除 main 外的所有本地分支
echo "正在删除除 main 外的所有本地分支..."
git branch | grep -v "main" | xargs git branch -D

# 删除所有本地 tag
echo "正在删除所有本地 tag..."
git tag -l | xargs git tag -d

# 删除除 main 外的所有远程分支
echo "正在删除除 main 外的所有远程分支..."
git branch -r | grep -v "main" | sed 's/origin\///g' | xargs -I {} git push origin --delete {}

# 删除所有远程 tag
echo "正在删除所有远程 tag..."
git ls-remote --tags origin | awk '{print $2}' | sed 's/refs\/tags\///g' | xargs -I {} git push --delete origin {}

# 清空历史提交记录并强制推送到远程仓库
echo "正在清空历史提交记录并强制推送到远程仓库..."
rm -rf .git
git init
git add -A .
git commit -m "Initial commit"
git remote add origin $(git config --get remote.origin.url)
git push -f origin main

echo "完成！"
