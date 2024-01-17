#!/bin/bash
# 更新代码
cd /opt/FreshRSS
git pull

# 重置权限
chown -R www:www /opt/FreshRSS

# 重启服务
systemctl restart php-fpm.service

# 重启 nginx
systemctl restart nginx.service

# 更新代码
cd "/data/FileFlow" || exit
git pull

# 重置权限
chown -R www:www /data/FileFlow

# 重启 nginx
systemctl restart nginx.service
