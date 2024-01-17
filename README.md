# 自动安装脚本

### 介绍
{**以下是 Gitee 平台说明，您可以替换此简介**
这是常用脚本的一些集合，特别是针对一些常用应用GitHub 代码加速的安装

> 脚本的执行请使用 `bash`，使用 `sh` 在 Ubuntu 和 Debian 中会报错，因为ubuntu 默认的sh是连接到dash 的，又因为dash 跟 bash 的不兼容所以出错。

### 安装教程


#### ohmyzsh 官方加速安装

```bash
sh -c "$(curl -fsSL https://raw.gitmirror.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sed 's#-ohmyzsh/ohmyzsh#-mirrors/ohmyzsh#; s#github.com/\$#gitee.com/\$#')"
```

#### debain/ubuntu 安装 nginx

```shell
bash -c "$(curl -fsSL https://gitee.com/maximohub/automatic/raw/main/debain/nginx_install.sh)"
```

#### PVE USTC

```shell
bash -c "$(curl -fsSL https://gitee.com/architectsky/automatic/raw/main/tools/pve_ustc.sh)"
```

#### 清华源

> 切换清华源 & 更新 & 安装一些基本应用
```shell
bash -c "$(curl -fsSL https://gitee.com/maximohub/automatic/raw/master/tools/basic_install.sh)"
```

#### NVM

```shell
bash -c "$(curl -fsSL https://gitee.com/maximohub/automatic/raw/master/tools/nvm_install.sh)"
```

#### Docker && docker-compose
```shell
bash -c "$(curl -fsSL https://gitee.com/maximohub/automatic/raw/master/tools/docker_install.sh)"
```

#### docker-compose 
```shell
bash -c "$(curl -fsSL https://gitee.com/maximohub/automatic/raw/master/tools/docker-compose_install.sh)"
```






xk0x6ozwn941f2gsdym4urdwajiqo242