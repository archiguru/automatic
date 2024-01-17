#!/bin/bash

modir /data/joplin

cd /data/joplin

# 检查操作系统和架构
OS=$(lsb_release -is)
ARCH=$(uname -m)

# 安装依赖包
install_dependencies() {
    if [[ "$OS" == "Ubuntu" || "$OS" == "Debian" ]]; then
        apt update
        apt install -y build-essential curl unzip postgresql postgresql-contrib nginx
    else
        echo "不支持的操作系统：$OS"
        exit 1
    fi
}

# 设置 PostgreSQL 用户和数据库参数
set_postgres_variables() {
    export DB_CLIENT=pg
    export POSTGRES_PASSWORD=maximo_joplin
    export POSTGRES_DATABASE=joplin_db
    export POSTGRES_USER=joplinadmin
    export POSTGRES_PORT=5432
    export POSTGRES_HOST=localhost
}

# 从源代码构建 Joplin Server
build_joplin_server() {
    git clone https://github.com/laurent22/joplin-server.git
    cd joplin-server
    npm install
    npm run build
}

# 启动 PostgreSQL 服务
start_postgres_service() {
    if systemctl start postgresql; then
        echo "PostgreSQL started successfully."
    else
        echo "Failed to start PostgreSQL."
        exit 1
    fi
}

# 创建 PostgreSQL 用户和数据库（仅当不存在时）
create_postgres_user_and_db() {
    if sudo -u postgres psql -t -c "SELECT 1 FROM pg_database WHERE datname='$POSTGRES_DATABASE'" | grep -q 1; then
        echo "数据库 $POSTGRES_DATABASE 已存在。"
    else
        echo "正在创建数据库 $POSTGRES_DATABASE..."
        sudo -u postgres psql -c "CREATE DATABASE $POSTGRES_DATABASE OWNER $POSTGRES_USER;"
    fi

    if sudo -u postgres psql -t -c "SELECT 1 FROM pg_user WHERE usename='$POSTGRES_USER'" | grep -q 1; then
        echo "用户 $POSTGRES_USER 已存在。"
    else
        echo "正在创建用户 $POSTGRES_USER..."
        sudo -u postgres psql -c "CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';"
        sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DATABASE TO $POSTGRES_USER;"
    fi
		}

# 配置和优化 PostgreSQL
configure_postgres() {
    echo "正在配置 PostgreSQL 以获取更好的性能..."
    sed -i "s/#max_connections = 100/max_connections = 200/" /etc/postgresql/*/main/postgresql.conf
    sed -i "s/#shared_buffers = 128MB/shared_buffers = 1GB/" /etc/postgresql/*/main/postgresql.conf
    sed -i "s/#effective_cache_size = 4GB/effective_cache_size = 8GB/" /etc/postgresql/*/main/postgresql.conf
    sed -i "s/#work_mem = 4MB/work_mem = 16MB/" /etc/postgresql/*/main/postgresql.conf
    sed -i "s/#maintenance_work_mem = 64MB/maintenance_work_mem = 256MB/" /etc/postgresql/*/main/postgresql.conf

    # 重启 PostgreSQL 以应用配置更改
    systemctl restart postgresql
}

# 设置 Joplin Server 环境变量
set_joplin_server_env_variables() {
    export JOPLIN_SERVER_PORT=22330
    export JOPLIN_SERVER_IP=0.0.0.0
    export JOPLIN_SERVER_TLS=false
    export JOPLIN_SERVER_TOKEN=your_token_here
    export JOPLIN_SERVER_BASE_URL=/joplin
    export JOPLIN_SERVER_DB_TYPE=$DB_CLIENT
    export JOPLIN_SERVER_DB_HOST=$POSTGRES_HOST
    export JOPLIN_SERVER_DB_PORT=$POSTGRES_PORT
    export JOPLIN_SERVER_DB_USER=$POSTGRES_USER
    export JOPLIN_SERVER_DB_PASSWORD=$POSTGRES_PASSWORD
    export JOPLIN_SERVER_DB_NAME=$POSTGRES_DATABASE
    export JOPLIN_SERVER_DATA_DIR=/data/joplin
}

# 创建 Joplin Server 数据目录
create_joplin_server_data_dir() {
    mkdir -p $JOPLIN_SERVER_DATA_DIR
}



# 修改 Joplin Server 配置文件
configure_joplin_server() {
    cd joplin-server
    cp env.template .env

    sed -i "s/JOPLIN_SERVER_PORT=/JOPLIN_SERVER_PORT=$JOPLIN_SERVER_PORT/" .env
    sed -i "s/JOPLIN_SERVER_IP=/JOPLIN_SERVER_IP=$JOPLIN_SERVER_IP/" .env
    sed -i "s/JOPLIN_SERVER_TLS=/JOPLIN_SERVER_TLS=$JOPLIN_SERVER_TLS/" .env
    sed -i "s/JOPLIN_SERVER_TOKEN=/JOPLIN_SERVER_TOKEN=$JOPLIN_SERVER_TOKEN/" .env
    sed -i "s/JOPLIN_SERVER_BASE_URL=/JOPLIN_SERVER_BASE_URL=$JOPLIN_SERVER_BASE_URL/" .env
    sed -i "s/JOPLIN_SERVER_DB_TYPE=/JOPLIN_SERVER_DB_TYPE=$JOPLIN_SERVER_DB_TYPE/" .env
    sed -i "s/JOPLIN_SERVER_DB_HOST=/JOPLIN_SERVER_DB_HOST=$JOPLIN_SERVER_DB_HOST/" .env
    sed -i "s/JOPLIN_SERVER_DB_PORT=/JOPLIN_SERVER_DB_PORT=$JOPLIN_SERVER_DB_PORT/" .env
    sed -i "s/JOPLIN_SERVER_DB_USER=/JOPLIN_SERVER_DB_USER=$JOPLIN_SERVER_DB_USER/" .env
    sed -i "s/JOPLIN_SERVER_DB_PASSWORD=/JOPLIN_SERVER_DB_PASSWORD=$JOPLIN_SERVER_DB_PASSWORD/" .env
    sed -i "s/JOPLIN_SERVER_DB_NAME=/JOPLIN_SERVER_DB_NAME=$JOPLIN_SERVER_DB_NAME/" .env
    sed -i "s/JOPLIN_SERVER_DATA_DIR=/JOPLIN_SERVER_DATA_DIR=$JOPLIN_SERVER_DATA_DIR/" .env
}

# 创建 systemd 服务配置文件
create_systemd_service_file() {
    cat >/etc/systemd/system/joplin-server.service <<EOL
[Unit]
Description=Joplin Server
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$PWD/joplin-server
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=3
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=joplin-server

[Install]
WantedBy=multi-user.target
EOL
}


# 配置 Nginx 反向代理
configure_nginx() {
    # 自动获取 Nginx 配置文件位置
    nginx_sites_available_dir="/usr/local/openresty/nginx/conf/vhost"

    echo "配置 Nginx 反向代理..."
    cat >"$nginx_sites_available_dir/note.eoysky.com.conf" <<EOL
server {
    listen 80;
    server_name note.eoysky.com;

    location /joplin/ {
        proxy_pass http://127.0.0.1:$JOPLIN_SERVER_PORT/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOL
    systemctl restart nginx
}

# 安装依赖包
install_dependencies

# 设置 PostgreSQL 用户和数据库参数
set_postgres_variables

# 启动 PostgreSQL 服务
start_postgres_service

# 创建 PostgreSQL 用户和数据库
create_postgres_user_and_db

# 配置和优化 PostgreSQL
configure_postgres

# 从源代码构建 Joplin Server
build_joplin_server

# 设置 Joplin Server 环境变量
set_joplin_server_env_variables

# 创建 Joplin Server 数据目录
create_joplin_server_data_dir

# 修改 Joplin Server 配置文件
configure_joplin_server

# 创建 systemd 服务配置文件
create_systemd_service_file

# 启动 Joplin Server
systemctl start joplin-server

# 设置 Joplin Server 开机自启动
systemctl enable joplin-server

# 配置 Nginx 反向代理
configure_nginx

# 正常退出脚本
exit 0
		
		
		
		
		