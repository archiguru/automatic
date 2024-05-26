#!/bin/bash
# ************* 系统设置 **************
# 允许打开任何来源的应用
sudo spctl --master-disable

# ************* 电源管理 **************



# ************* Xcode Command Line Tools **************
# 安装方法
code-select --install
# 重新安装
# sudo rm -rf /Library/Developer/CommandLineTools && xcode-select --install

exit 0
