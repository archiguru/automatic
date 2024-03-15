#!/bin/bash
sudo -i
sudo sed -i "s/\$nrconf{restart}/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
sudo cat /dev/null >/etc/legal

sshd_conf_file="/etc/ssh/sshd_config"
comment="# User configuration"
content_to_add="PrintLastLog no
PermitRootLogin yes
PubkeyAuthentication yes
TCPKeepAlive yes
ClientAliveInterval 60
ClientAliveCountMax 3600"

# 查找用户自定义注释所在行号
comment_line=$(grep -n "$comment" "$sshd_conf_file" | cut -d ':' -f 1)

if [ -n "$comment_line" ]; then
    # 如果找到注释，则在注释所在行替换内容
    sed -i'' "${comment_line}c\\$comment\n$content_to_add" "$sshd_conf_file"
else
    # 如果未找到注释，则在末尾添加内容
    echo "$comment" >> "$sshd_conf_file"
    echo "$content_to_add" >> "$sshd_conf_file"
fi

#sudo cat >"/home/ubuntu/.ssh/authorized_keys" <<EOF
#ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5AKSY8s8J5gq+XRhN46ccIBKt9TSk4XC+1o+UjwzPt MacBot
#EOF
sudo cat >"/root/.ssh/authorized_keys" <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5AKSY8s8J5gq+XRhN46ccIBKt9TSk4XC+1o+UjwzPt MacBot
EOF
sudo sed -i "s/\$nrconf{restart}/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf
sudo systemctl restart sshd.service
sudo cp -rf /etc/update-motd.d /etc//update-motd.d.backup
sudo rm -rf /etc/update-motd.d/*
sudo NEEDRESTART_MODE=a apt-get dist-upgrade --yes
sudo apt-get update -y && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common build-essential gcc gcc-11-locales autoconf automake make libtool flex bison git bzr libgd-tools expect lrzsz zip unzip bzip2 zsh screen wget rsync lsof telnet tree htop vim net-tools universal-ctags gnupg2 jq cron socat gdb chrony gsmartcontrol hwloc psmisc debian-keyring
sudo ufw disable
timedatectl set-local-rtc 1
timedatectl set-timezone Asia/Shanghai
systemctl start chrony
systemctl enable chrony

sudo echo "export HISTTIMEFORMAT=\"%F %T \"" >>/etc/profile
sudo echo "" >>/etc/profile
sudo echo "alias c=clear" >>/etc/profile
sudo echo "alias rm='rm -rf'" >>/etc/profile
sudo echo "alias cp='cp -r'" >>/etc/profile
sudo echo "alias mv='mv -rf'" >>/etc/profile
sudo echo "alias vi=vim" >>/etc/profile
sudo echo "alias dsh='du -hsx * | sort -rh | head -n 10'" >>/etc/profile
sudo sed -i 's/HISTSIZE=1000/HISTSIZE=10000/g' /etc/profile
source /etc/profile

cat >>/etc/security/limits.conf <<EOF
*           soft   nofile       65535
*           hard   nofile       65535
EOF

cd /bin
ln -sf bash sh

sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
sudo apt-get purge netfilter-persistent -y

sudo apt install firewalld -y
sudo systemctl stop firewalld
sudo systemctl disable firewalld

sudo reboot
