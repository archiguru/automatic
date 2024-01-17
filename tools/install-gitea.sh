#!/usr/bin/env bash
cd ~ 

# 创建/data/gitea相关目录
mkdir -p /data/gitea/mariadb
mkdir -p /data/gitea/data

# 在/data/gitea目录下创建docker-compose.yml文件
cat > /data/gitea/docker-compose.yml <<EOF
version: '3'
services:
  gitea:
    image: gitea/gitea:latest
    restart: always
    environment:
      - USER_UID=1000
      - USER_GID=1000
      - DB_TYPE=mysql
      - DB_HOST=db:3306
      - DB_NAME=gitea_db
      - DB_USER=gitea
      - DB_PASSWD=giteapawd
      #- GITEA__server__DOMAIN=example.com
      #- GITEA__server__ROOT_URL=https://example.com/
    volumes:
      - /data/gitea/data:/data
    ports:
      - "23300:3000"
      - "2222:22"
    depends_on:
      - db
  db:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: gitea_passwd
      MYSQL_USER: gitea
      MYSQL_PASSWORD: giteapawd
      MYSQL_DATABASE: gitea_db
    volumes:
      - /data/gitea/mariadb:/var/lib/mysql

EOF

# 在/data/gitea目录中运行docker-compose up -d命令以启动Gitea和MariaDB容器
cd /data/gitea && sudo docker-compose up -d

# 获取服务器的IP地址并输出提示信息
server_ip=$(hostname -I | awk '{print $1}')
echo "Gitea已安装完成，您可以访问 http://${server_ip}:23300/install 完成安装。"
