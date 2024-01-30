#!/usr/bin/env bash

read -p "请输入用户名：" name
read -p "请输入邮箱：" email

git config --global user.name "$name"
git config --global user.email "$email"
git config --list

read -p "是否需要生成 ssh-key ？（y|n）" genKey

if [ "y" == $genKey ]; then
	read -p "请输入密码短语: " passphrase
	ssh-keygen -t ed25519 -C "$passphrase"
fi

exit 0
