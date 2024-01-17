#!/bin/bash

# 定义一个函数，用于检查是否有冲突并给出解决示例
check_conflict() {
    # 检查是否有冲突
    if [ $? -ne 0 ]; then
        echo "出现冲突，请处理冲突后再继续操作。"
        # 解决冲突提示给出完整的处理示例，并将要处理文件名动态展示出来，以便用户直接复制命令进行操作。
        conflict_files=$(git diff --name-only --diff-filter=U)
        if [ -n "$conflict_files" ]; then
            echo "以下文件存在冲突，请手动解决："
            echo "$conflict_files"
            echo ""
            echo "可以使用以下命令查看每个文件中的具体冲突："
            for file in $conflict_files; do
                echo "git diff $file"
            done
            echo ""
            echo "解决完冲突后，使用以下命令将解决冲突的文件添加到暂存区："
            for file in $conflict_files; do
                echo "git add $file"
            done
            echo ""
            echo "然后使用 'git commit' 命令提交更改。"
        fi
        exit 1
    fi
}

# 更新远程仓库内容
echo "正在更新远程仓库内容..."
git fetch --all

# 更新本地所有分支
echo "正在更新本地所有分支..."
git pull --all

# 提示用户是否要 merge 某个分支
echo "请输入要 merge 的分支名称（留空则不进行 merge）："
read branch

# 如果用户输入了分支名称，则进行 merge 操作
if [ -n "$branch" ]; then
    git merge $branch

    # 调用 check_conflict 函数检查是否有冲突并给出解决示例
    check_conflict
fi

# 将整个工作目录中的所有更改添加到暂存区
echo "正在将整个工作目录中的所有更改添加到暂存区..."
git add -A

# 获取当前时间和当前用户
current_time=$(date "+%Y-%m-%d %H:%M:%S")
current_user=$(git config user.name)
hostname=$(hostname)

# 提示用户是否要自动生成提交内容
echo "是否要自动生成提交内容？（y/n，默认为 y）："
read auto_commit

# 如果用户选择自动生成提交内容或直接按回车键确认，则根据当前时间和当前用户生成提交内容
if [ "$auto_commit" != "n" ]; then
    commit_message="自动提交：用户 $current_user 在 $hostname 于 $current_time 提交"

# 否则，提示用户输入提交内容
else
    echo "请输入提交内容："
    read commit_message
fi

# 提交更改
echo "正在提交更改..."
git commit -m "$commit_message"

