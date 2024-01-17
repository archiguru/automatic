#!/bin/bash

# 设置仓库的名称
repo_name="automatic"

# 判断操作系统的类型
if [ "$(uname)" == "Darwin" ]; then
    # 如果是 Mac OS，就使用当前目录作为仓库路径
    repo=$(pwd)
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # 如果是 Linux，就使用 /opt/src/ 下的仓库名称作为仓库路径
    repo="/opt/src/$repo_name/"
fi

# 进入仓库目录，如果失败就退出
cd $repo || exit

# 显示当前的远程仓库地址
git remote -v

# 删除原有的 git 信息
rm -rf .git

# 重新初始化 git
git init

# 添加远程仓库地址，使用 gitee.com 上的仓库
git remote add origin "git@gitee.com:archiguru/$repo_name.git"

# 添加所有文件并提交，使用 "first commit" 作为提交信息
git add -A && git commit -m "first commit"

# 强制推送到远程仓库的 main 分支，覆盖原有的内容
git push -u origin main --force
