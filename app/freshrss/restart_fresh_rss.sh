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

rsshub
CREATE DATABASE $(freshrssdb) DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
create user 'rsshub'@'localhost' identified by 'Arch@1203';
GRANT ALL PRIVILEGES on freshrssdb.* to 'rsshub'@'localhost';
FLUSH PRIVILEGES;



Access to database is denied for `rsshub`: SQLSTATE[HY000] [1045] Access denied for user 'rsshub'@'localhost' (using password: YES)