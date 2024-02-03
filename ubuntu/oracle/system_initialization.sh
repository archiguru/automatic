#!/bin/bash
sudo sed -i "s/\$nrconf{restart}/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
sudo cat /dev/null >/etc/legal
sudo tee -a /etc/ssh/sshd_config <<EOF
PrintLastLog no
PermitRootLogin yes
PubkeyAuthentication yes
TCPKeepAlive yes
ClientAliveInterval 60
ClientAliveCountMax 3600
EOF
sudo cat >"/home/ubuntu/.ssh/authorized_keys" <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5AKSY8s8J5gq+XRhN46ccIBKt9TSk4XC+1o+UjwzPt MacBot
EOF
sudo cat >"/root/.ssh/authorized_keys" <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5AKSY8s8J5gq+XRhN46ccIBKt9TSk4XC+1o+UjwzPt MacBot
EOF
sudo sed -i "s/\$nrconf{restart}/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf
sudo systemctl restart sshd.service
sudo cp -rf /etc/update-motd.d /etc//update-motd.d.backup
sudo rm -rf /etc/update-motd.d/*
sudo NEEDRESTART_MODE=a apt-get dist-upgrade --yes
sudo apt-get update -y
sudo apt-get install build-essential ufw cron socat zsh screen zip unzip wget rsync bzip2 lsof telnet git tree htop vim net-tools universal-ctags apt-transport-https ca-certificates curl software-properties-common gcc gcc-11-locales debian-keyring autoconf automake make libtool flex bison gdb bzr libgd-tools expect lrzsz chrony gsmartcontrol hwloc psmisc -y
sudo ufw disable
timedatectl set-local-rtc 1
timedatectl set-timezone Asia/Shanghai
systemctl start chrony
systemctl enable chrony

sudo echo "export HISTTIMEFORMAT=\"%F %T \"" >>/etc/profile
sudo echo "" >>/etc/profile
sudo echo "alias c=clear" >>/etc/profile
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

# 开启或清除iptables
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
sudo apt-get purge netfilter-persistent -y

# 然后停用防火墙

sudo systemctl stop firewalld
sudo systemctl disable firewalld

# 直接删除iptables规则
sudo rm -rf /etc/iptables && reboot
