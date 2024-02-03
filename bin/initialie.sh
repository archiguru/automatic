#!/bin/bash
#****************************************
# 作者: ArchiGuru
# 创建时间: 2024-01-30 16:34
# 文件名: initialie.sh
# 描述: 初始化 Git 仓库并根据用户选择设置远程 origin。
#****************************************

# 函数：选择代码托管平台
choose_platform() {
    echo "请选择使用的代码托管平台："
    echo "1. GitHub"
    echo "2. Gitee"

    read -p "请输入选项的数字编号：" choice
    case $choice in
        1) git_url="git@github.com" ;;
        2) git_url="git@gitee.com" ;;
        *) echo "无效的选项，请重新选择！" && choose_platform ;;
    esac
}

# 提示用户选择平台
choose_platform

# 验证代码托管平台
if [[ "$git_url" != "git@github.com" && "$git_url" != "git@gitee.com" ]]; then
    echo "Git URL无效。退出脚本。"
    exit 1
fi

# 输入用户自定义的仓库
read -p "请输入您的仓库名: " git_repo

# 定义用户名
git_user="archiguru"

echo -e "\n\n**************************\n"
echo "您选择的代码托管平台是：$git_url"
echo "您要初始化的仓库名是：$git_repo"
echo "您的用户名为：$git_user"
echo -e "\n**************************\n\n"

read -p "确认是否继续？（Y/n）: " is_continue

if [[ "$is_continue" != "Y" && "$is_continue" != "y" ]]; then
    echo "退出脚本。"
    exit 1
fi

# 根据操作系统确定仓库路径
if [ "$(uname)" == "Darwin" ]; then
    repo=$(pwd)
elif [ "$(uname -s)" == "Linux" ]; then
    repo="/data/GitHub/$git_repo/"
else
    echo "不支持的操作系统。退出脚本。"
    exit 1
fi

# 切换到仓库目录
cd "$repo" || exit

# 检查是否存在 .git 目录
if [ ! -d ".git" ]; then
    echo "在当前目录下未找到 .git 目录。退出脚本。"
    exit 1
fi

# 初始化 Git 仓库
git init

# 检查当前分支名是否为 main，如果不是则修改分支名为 main
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    git branch -m "$current_branch" "main"
    echo "分支名已修改为 main。"
fi

# 添加远程 origin
git remote add origin "$git_url:$git_user/$git_repo.git"

# 添加并提交修改
git add -A && git commit -m "first commit"

# 推送修改到远程仓库
git push -u origin main --force

echo "初始化完成。"
exit 0
