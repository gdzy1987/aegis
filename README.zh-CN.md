[English](README.md) | 简体中文

<p align="center">
    <img src="https://cdn.jsdelivr.net/gh/seatonjiang/aegis@main/.github/aegis.png">
</p>

<p align="center">
    <img src="https://img.shields.io/static/v1?style=flat-square&message=Ubuntu&color=E95420&logo=Ubuntu&logoColor=FFFFFF&label=">
    <a href="https://github.com/seatonjiang/aegis/issues">
        <img src="https://img.shields.io/github/issues/seatonjiang/aegis?style=flat-square&color=blue">
    </a>
    <a href="https://github.com/seatonjiang/aegis/pulls">
        <img src="https://img.shields.io/github/issues-pr/seatonjiang/aegis?style=flat-square&color=brightgreen">
    </a>
    <a href="https://github.com/seatonjiang/aegis/blob/main/LICENSE">
        <img src="https://img.shields.io/github/license/seatonjiang/aegis?&style=flat-square">
    </a>
</p>

<p align="center">
    <a href="https://github.com/seatonjiang/aegis/issues">报告问题</a>
    ·
    <a href="https://github.com/seatonjiang/aegis/issues">功能需求</a>
</p>

<p align="center">针对 Ubuntu 服务器的系统安全加固工具</p>

## 💻 工具截图

### 脚本执行

<p align="center">
    <img src="https://cdn.jsdelivr.net/gh/seatonjiang/aegis@main/.github/script-execution.png">
</p>

### 登录信息

<p align="center">
    <img src="https://cdn.jsdelivr.net/gh/seatonjiang/aegis@main/.github/login-information.png">
</p>

### 挂载硬盘

<p align="center">
    <img src="https://cdn.jsdelivr.net/gh/seatonjiang/aegis@main/.github/mount-disk.png">
</p>

## ✨ 工具特性

- 限制密码使用期限为 30 天。
- 密码过期 30 天后，该账户将被禁用。
- 设置两次修改密码的时间间隔为 1 天。
- 在密码过期前 7 天将发出警告。
- 将系统默认加密算法设置为 SHA512。
- 将会话超时策略设置为 900 秒。
- 为新建的用户创建并加入一个同名的组。
- 将新建用户的 home 目录权限设置为 0750。
- 将存量用户的 home 目录权限设置为 0750。
- 删除没有用的用户以及软件包。
- 强化 OpenSSH 配置（有些配置需要手动配置）。
- 禁止没有 home 目录的用户登录。
- 禁止新建的用户使用 SHELL 登录。
- 禁止上传和用户信息的功能。
- 禁用 motd 中的广告组件。
- 禁用 root 帐户。
- 禁止删除用户时同步删除该用户的组。

还有很多特性没有被列举出来，可以参考 `scripts` 目录下的文件了解更多信息。

## 🚀 使用说明

### 第一步：克隆仓库

确保服务器安装了 Git，否则需要先用 `sudo apt install git` 命令安装软件：

```bash
git clone https://github.com/seatonjiang/aegis.git
```

如果因为网络问题无法连接，可以使用国内镜像仓库，但是镜像仓库会有 `30` 分钟的延迟：

```bash
git clone https://gitee.com/seatonjiang/aegis.git
```

### 第二步：编辑配置

进入项目文件夹：

```bash
cd aegis
```

核对配置文件中的配置信息（配置文件说明在下文）：

```bash
vim aegis.conf
```

### 第三步：运行脚本

如果是 root 账号，可以直接运行，如果是普通账号，需要使用 `sudo` 运行，而且必须用 `bash` 运行该脚本：

```bash
sudo bash aegis.sh
```

## 📝 配置文件

```ini
# 每一项操作完成后进行验证
VERIFY='Y'

# 在 motd 中添加生产环境的提示
PROD_TIPS='Y'

# 修改 SSH 端口，范围建议在 10000-65535 选择
SSH_PORT='22'

# 修改时区
TIME_ZONE='Asia/Shanghai'

# 修改主机名称（腾讯云、阿里云、华为云自动拉取元数据）
HOSTNAME='Ubuntu-Server'

# 修改 DNS 服务器（腾讯云、阿里云、华为云自动拉取元数据）
DNS_SERVER='119.29.29.29'

# 修改 NTP 服务器（腾讯云、阿里云、华为云自动拉取元数据）
NTP_SERVER='ntp.ntsc.ac.cn'
```

## 🔨 独立功能

Aegis 中包含了一些独立的功能，这些功能并不在自动执行的脚本中，需要使用参数单独使用，可以使用 `sudo bash aegis.sh --help` 命令查看所有独立功能。

### 清理垃圾

清理所以的系统日志、缓存文件、备份文件以及字体文件。

> 某些 VPS 服务商（~~没有特指腾讯云~~）提供的镜像由于制作的过程不规范，导致打包了一些垃圾文件到镜像中，建议使用这些服务商的朋友，初始化系统之前先清理系统垃圾。

```bash
sudo bash aegis.sh --clear
```

### 挂载硬盘

交互式挂载数据盘（腾讯云将使用弹性云硬盘的软链接方式挂载），数据无价，操作过程切记小心！

> 如果所选的硬盘已经被挂载，将会提示解除挂载及格式化操作。

```bash
sudo bash aegis.sh --fdisk
```

### 修改端口

交互式修改 SSH 端口。

> 端口范围建议在 10000 到 65535 之间。

```bash
sudo bash aegis.sh --aegis_sshport
```

### 安装 Docker

安装 Docker 服务并设置镜像加速（腾讯云、阿里云、华为云自动使用其自有加速地址），添加非 `root` 账号的运行权限。

> 安装完成后，请退出当前账号并重新登录，然后测试 Docker 的相关功能是否正常不报错。

```bash
sudo bash aegis.sh --docker
```

## 📂 目录结构

下面是整个项目的文件夹结构，`config` 及 `scripts` 文件夹中的文件省略显示。

```bash
aegis
├── aegis.conf
├── aegis.sh
├── config
│   └── (some config files)
└── scripts
    └── (some script files)
```

## 🤝 参与共建

我们欢迎所有的贡献，你可以将任何想法作为 pull requests 或 GitHub issues 提交，顺颂商祺 :)
