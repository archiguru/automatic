#!/bin/bash

# 更新代码
cd /var/www/FreshRSS
git pull

# 重置权限
chown -R nginx:nginx /var/www/FreshRSS

# 重启服务
systemctl restart php-fpm.service

# 重启 nginx
systemctl restart nginx.service
