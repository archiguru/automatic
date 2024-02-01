#!/bin/bash

apt install -y git zsh wget curl
cd ~
curl -fsSL https://gitee.com/mirrors/ohmyzsh/raw/master/tools/install.sh >./install.sh
chmod +x install.sh
sed -i 's/-https:\/\/github.com/-https:\/\/gitee.com/g' install.sh
sed -i 's/-ohmyzsh\/ohmyzsh/-mirrors\/ohmyzsh/g' install.sh
sh ./install.sh
exit
