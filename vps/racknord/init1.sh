#!/bin/bash
# 设置系统的主机名
hostnamectl set-hostname racknord-us.eoysky.com
# 设置系统的美化主机名
hostnamectl set-hostname "Archiguru's racknord-us Computer" --pretty
# 显示当前的系统信息，包括主机名
hostnamectl

# 备份原始的 MOTD 配置目录（登录时显示的消息）
cd /etc/
sudo mv update-motd.d update-motd.d.bak
sudo mkdir update-motd.d
cd $HOME

mkdir $HOME/.ssh/
touch $HOME/home/archiguru/.ssh/authorized_keys
# ssh 配置
cat <<EOF > $HOME/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQ8ZoDx2u6lbkkIqsQOBbvf6AuiFpc5pZhFI6om4xo1 iPhone
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMT5NVu9cHINNx0BgCUVSSXKa/mUzLKe42dathsxcQYu macOS
EOF
CONFIG_FILE="/etc/ssh/sshd_config.d/custom.conf"
echo "PermitRootLogin yes" >> "$CONFIG_FILE"
echo "PasswordAuthentication yes" >> "$CONFIG_FILE"
echo "PubkeyAuthentication yes" >> "$CONFIG_FILE"
echo "ClientAliveInterval 60" >> "$CONFIG_FILE"
echo "ClientAliveCountMax 99999" >> "$CONFIG_FILE"
// sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# 下载工具箱
curl -sS -o /usr/local/bin/toolbox.sh https://kejilion.pro/kejilion.sh && chmod +x /usr/local/bin/toolbox.sh

# 安装常用工具
sudo apt-get update -y
sudo apt-get install -y git htop curl wget vim tree screenfetch tmux zsh rsync docker nmap ufw gcc clang make cmake autoconf automake
sudo apt-get autoremove -y && echo "命令行工具安装完成。"

# 配置 zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
chsh -s /bin/zsh
# 新建用户
sudo useradd -m -s /bin/zsh -G sudo archiguru
sudo usermod -p "rain8240" archiguru
sudo usermod -c "Jonny Chang" archiguru
cp -rf /root/.oh-my-zsh /home/archiguru/.oh-my-zsh
cp -ff /root/.zshrc /home/archiguru/.zshrc
mkdir /home/archiguru/.ssh/
touch /home/archiguru/.ssh/authorized_keys
cat <<EOF > /home/archiguru/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQ8ZoDx2u6lbkkIqsQOBbvf6AuiFpc5pZhFI6om4xo1 iPhone
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMT5NVu9cHINNx0BgCUVSSXKa/mUzLKe42dathsxcQYu macOS
EOF
chmod 600 ~/.ssh/authorized_keys

# 更新软件包列表并静默升级
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y
sudo apt-get -yq upgrade
sudo update-grub

cd $HOME
curl -sS -o ${HOME}/tcpx.sh https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcpx.sh
sudo reboot