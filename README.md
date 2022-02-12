English | [简体中文](README.zh-CN.md)

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
    <a href="https://github.com/seatonjiang/aegis/issues">Report Bug</a>
    ·
    <a href="https://github.com/seatonjiang/aegis/issues">Request Feature</a>
</p>

<p align="center">System security hardening tool for Ubuntu Server</p>

## 💻 Screenshot

### Script Execution

<p align="center">
    <img src="https://cdn.jsdelivr.net/gh/seatonjiang/aegis@main/.github/script-execution.png">
</p>

### Login Information

<p align="center">
    <img src="https://cdn.jsdelivr.net/gh/seatonjiang/aegis@main/.github/login-information.png">
</p>

### Mount disk

<p align="center">
    <img src="https://cdn.jsdelivr.net/gh/seatonjiang/aegis@main/.github/mount-disk.png">
</p>

## ✨ Features

- Password can be used for a maximum of 30 days.
- After 30 days of password expiration, the account will be disabled.
- The interval between two password changes is 1 day.
- Warning 7 days before password expiration.
- Set the system default encryption algorithm to SHA512.
- Set a session timeout policy of 900 seconds.
- Each created user will be given their own group.
- The newly created user home directory permissions are changed to 0750.
- Modify the permissions of the home directory of the stock user to 0750.
- Remove useless users and packages.
- Hardened OpenSSH config (Some configs need to be done manually).
- Disable login for users without home directory.
- Disable login by default for new users.
- Disable apport and popular-contest statistics for uploading user information.
- Disable ads in the welcome message.
- Disable root account.
- Disable synchronous deletion of user groups when deleting users.

There are many more settings that are not listed, and you can refer to the files in the `scripts` directory for more information.

## 🚀 Quick start

### Step 1: Clone the repo

Make sure the server has git first, otherwise you need to install it using `sudo apt install git`.

```bash
git clone https://github.com/seatonjiang/aegis.git
```

### Step 2: Edit the config file

Go to project directory.

```bash
cd aegis
```

Be sure to authenticate the contents of the config file.

```bash
vim aegis.conf
```

### Step 3: Running script

If you are root, you can run it directly, if you are a normal user please use `sudo` and you must run the script with `bash`.

```bash
sudo bash aegis.sh
```

## 📝 Config options

```ini
# Verify at the completion of each operation.
VERIFY='Y'

# Add a production environment reminder in motd.
PROD_TIPS='Y'

# Modify the SSH port
# It is recommended to choose between 10000 and 65535.
SSH_PORT='22'

# Modify the Time zone
TIME_ZONE='Asia/Shanghai'

# Modify the hostname
# Tencent, Alibaba, HUAWEI Cloud will automatically get the metadata.
HOSTNAME='Ubuntu-Server'

# Modify the DNS server
# Tencent, Alibaba, HUAWEI Cloud will automatically get the metadata.
DNS_SERVER='119.29.29.29'

# Modify the NTP server
# Tencent, Alibaba, HUAWEI Cloud will automatically get the metadata.
NTP_SERVER='ntp.ntsc.ac.cn'

# Docker Compose version
DOCKER_COMPOSE='v2.2.3'
```

## 🔨 Modular

Aegis contains a number of standalone functions that are not in the auto-executed script and need to be used separately using parameters, which can be viewed using the `sudo bash aegis.sh --help` for all standalone functions.

### Clear system

Clear all system logs, cache and backup files.

```bash
sudo bash aegis.sh --clear
```

### Mount disk

Interactively mount the data disk (Tencent Cloud will use the soft link method of elastic cloud hard disk to mount), the data is priceless, remember to be careful during the operation!

> If the selected hard disk is already mounted, you will be prompted to unmount and format the operation.

```bash
sudo bash aegis.sh --fdisk
```

### Modify the SSH port

Interactively modify the SSH port.

> The port range is recommended to be between 10000 and 65535.

```bash
sudo bash aegis.sh --sshport
```

### Install docker

Install docker service and set registry mirrors (Tencent, Alibaba, HUAWEI Cloud automatically use their own acceleration address), and add run permission for non-root accounts.

> After installation, please log out and log back in, then test docker.

```bash
sudo bash aegis.sh --docker
```

### Uninstall agent

Remove the various monitoring components installed into the server by the cloud vendor.

> Tencent Cloud monitoring components are currently supported.

```bash
sudo bash aegis.sh --removeagent
```

## 📂 Structure

A quick look at the folder structure of this project.

```bash
aegis
├── aegis.conf
├── aegis.sh
├── config
│   └── (some config files)
└── scripts
    └── (some script files)
```

## 🤝 Contributing

We welcome all contributions. You can submit any ideas as pull requests or as issues, have a good time! :)

## 📃 License

The project is released under the GNU General Public License v3.0, see the [LICENCE](https://github.com/seatonjiang/aegis/blob/main/LICENSE) file for details.