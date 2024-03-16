#!/bin/bash
# 使用方法：
#    sudo bash -c "$(curl -fsSL https://gitee.com/archiguru/automatic/raw/main/oracle/init.sh)"
sudo -i
# needrestart 删除
apt autoremove -y --purge needrestart
#sudo sed -i "s/\$nrconf{restart}/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf
rm -rf /etc/needrestart
cd ~ || exit
sudo cat >"/etc/ssh/sshd_config.d/00-default.conf" <<EOF
# 默认 ssh 端口，生产环境中建议改成五位数的端口
Port 22822
# ssh 所使用的私钥路径
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
# 设定在记录来自 sshd 的消息的时候，是否给出 "facility code"
SyslogFacility AUTHPRIV

# 是否允许 root 账户 ssh 登录
PermitRootLogin yes
# 设置 ssh 在接收登录请求之前是否检查用户根目录和 rhosts 文件的权限和所有权，建议开启
StrictModes yes
# 是否开启公钥验证
PubkeyAuthentication yes
# 公钥验证文件路径
AuthorizedKeysFile .ssh/authorized_keys
# 是否在 RhostsRSAAuthentication 或 HostbasedAuthentication 过程中忽略用户的 ~/.ssh/known_hosts 文件
IgnoreUserKnownHosts yes
# 是否在 RhostsRSAAuthentication 或 HostbasedAuthentication 过程中忽略 .rhosts 和 .shosts 文件
IgnoreRhosts yes
# 是否允许密码验证，生产环境中建议改成no，只用密钥登录
PasswordAuthentication yes
# 是否允许质疑-应答(challenge-response)认证
ChallengeResponseAuthentication no
# 是否允许基于 GSSAPI 的身份验证
GSSAPIAuthentication yes
# 是否在用户退出登录后自动销毁用户凭证缓存
GSSAPICleanupCredentials no
# 是否通过PAM验证
UsePAM yes
# 是否允许X11转发
X11Forwarding yes
# 是否允许 TCP 转发
AllowTcpForwarding yes
# 是否允许远程主机连接本地的转发端口
GatewayPorts yes
# 是否允许用户打印 /etc/motd 文件的内容
PrintMotd no
# 是否允许在每一次交互式登录时打印最后一位用户的登录时间
PrintLastLog no
# 指定系统是否向客户端发送 TCP keepalive 消息
TCPKeepAlive yes
# 是否在交互式会话的登录过程中使用 login
UseLogin yes
# 是否在交互式会话的登录过程中使用
UseLogin yes
# 长时间没有收到客户端的任何数据，不发送 "alive" 消息
ClientAliveInterval 60
# 在未收到任何客户端回应前最多允许发送多个 "alive" 消息，默认值是
ClientAliveCountMax 7200
# 是否允许 tun 设备转发 
PermitTunnel yes
# 禁用将指定的文件中的内容在用户进行认证前显示给远程用户
Banner none
# DNS PTR 反向查询客户端主机名，开启会影响登录速度
UseDNS no
# 允许客户端通过环境变量指定的值
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES 
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT 
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE 
AcceptEnv XMODIFIERS
EOF

# 清空/etc/legal文件
sudo cat /dev/null >/etc/legal

# 设置中文
sudo locale-gen zh_CN.UTF-8
sudo cat >"/etc/default/locale" <<EOF
# LANG=en_US.UTF-8
# LANGUAGE=en_US:en
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:en_US:en"
LC_ALL="zh_CN.UTF-8"
EOF

# 检查/home/ubuntu/.ssh/文件夹是否存在，如果不存在则创建
if [ ! -d "/home/ubuntu/.ssh/" ]; then
    mkdir -p "/home/ubuntu/.ssh/"
fi

# 创建 /home/ubuntu/.ssh/authorized_keys 文件并添加密钥
sudo cat >"/home/ubuntu/.ssh/authorized_keys" <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5AKSY8s8J5gq+XRhN46ccIBKt9TSk4XC+1o+UjwzPt MacBot
EOF

# 检查/root/.ssh/文件夹是否存在，如果不存在则创建
if [ ! -d "/root/.ssh/" ]; then
    mkdir -p "/root/.ssh/"
fi

# 创建 /root/.ssh/authorized_keys 文件并添加密钥
sudo cat >"/root/.ssh/authorized_keys" <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5AKSY8s8J5gq+XRhN46ccIBKt9TSk4XC+1o+UjwzPt MacBot
EOF

# 重启sshd服务
sudo systemctl restart sshd.service

# 检查 /etc/update-motd.d.backup 文件夹是否存在，如果不存在则进行备份
if [ ! -d "/etc/update-motd.d.backup" ]; then
    sudo cp -rf /etc/update-motd.d /etc/update-motd.d.backup
fi

# 清空 /etc/update-motd.d/ 目录内容
sudo rm -rf /etc/update-motd.d/*

# 更新软件源并安装软件包
sudo apt update -y && sudo apt install -y \
    apt-transport-https ca-certificates curl software-properties-common \
    build-essential gcc gcc-11-locales autoconf automake make libtool \
    flex bison git bzr libgd-tools expect lrzsz zip unzip bzip2 \
    zsh screen wget rsync lsof telnet tree htop vim net-tools \
    universal-ctags gnupg2 jq cron socat gdb chrony gsmartcontrol \
    hwloc psmisc debian-keyring ufw \
    language-pack-zh-hans

# 禁用防火墙
sudo ufw disable

# 配置 iptables 并删除 netfilter-persistent
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
sudo apt purge netfilter-persistent -y

# 安装 firewalld 并停止及禁用服务
sudo apt install firewalld -y
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# 下载并安装Go语言
cd $HOME || exit
# 获取包含版本号的页面内容
content=$(curl -s https://golang.google.cn/dl/)
# 解析内容以提取版本号
go_version=$(echo "$content" | grep -oP 'go[0-9]+\.[0-9]+\.[0-9]+' | head -1)
# clean_go_version=$(echo $go_version | cut -c3-)
echo "最新的 GoLang 版本是：$go_version"

wget https://go.dev/dl/${go_version}.linux-arm64.tar.gz
sudo rm -rf /usr/local/go && tar -C /usr/local -xzf ${go_version}.linux-arm64.tar.gz

# 设置本地RTC时间为本地时间
timedatectl set-local-rtc 1

# 设置系统时区为Asia/Shanghai
timedatectl set-timezone Asia/Shanghai

# 启动和设置chrony服务
systemctl start chrony
systemctl enable chrony

# 配置命令历史记录格式和别名
sudo cat >>"/etc/profile" <<EOF

export HISTTIMEFORMAT="%F %T "

alias c=clear
alias rm='rm -rf'
alias mv='mv -rf'
alias cp='cp -r'
alias vi=vim
alias dsh='du -hsx * | sort -rh | head -n 10'

EOF
source /etc/profile

# 创建 bash 到 /bin/sh 的符号链接
cd /bin || exit
ln -sf bash sh
cd $HOME || exit

# 执行系统升级
sudo apt dist-upgrade --yes

# 重启系统
sudo reboot
