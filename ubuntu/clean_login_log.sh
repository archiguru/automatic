#!/bin/bash

# 备份 /etc/update-motd.d/ 文件夹
sudo cp -r /etc/update-motd.d/ /etc/update-motd.d_backup/

# 清空 /etc/update-motd.d/ 文件夹下的所有文件
sudo rm -rf /etc/update-motd.d/*

# 设置 ssdh.conf
sudo sed -i 's/#PrintLastLog yes/PrintLastLog no/' /etc/ssh/sshd_config

# 清空当前用户的 lastlog 记录
sudo /usr/bin/lastlog -C -u "$(whoami)"
