#!/bin/bash
#
# aegis-docker.sh - Install docker service.
# Seaton Jiang <hi@seatonjiang.com>
#
# The latest version of Aegis can be found at:
# https://github.com/seatonjiang/aegis
#
# Copyright (C) 2021 Seaton Jiang
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

function aegis_docker()
{
    info_msg '\n%s\n' "Install docker service"

    # Uninstall Docker Engine
    apt-get remove docker docker-engine docker.io containerd runc -y

    # Install Dependencies
    apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y

    if [ -n "$(wget -qO- -t1 -T2 169.254.0.23)" ]; then
        # Tencent Cloud
        DOCKER_CE_MIRRORS='http://mirrors.tencentyun.com/docker-ce'
        DOCKER_MIRRORS='https://mirror.ccs.tencentyun.com'
    elif [ -n "$(wget -qO- -t1 -T2 100.100.100.200)" ]; then
        # Alibaba Cloud
        DOCKER_CE_MIRRORS='http://mirrors.cloud.aliyuncs.com/docker-ce'
        DOCKER_MIRRORS='https://registry.cn-hangzhou.aliyuncs.com'
    elif [ -n "$(wget -qO- -t1 -T2 169.254.169.254)" ]; then
        # HUAWEI Cloud
        DOCKER_CE_MIRRORS='http://mirrors.myhuaweicloud.com/docker-ce'
        DOCKER_MIRRORS='https://a786190f76fb41679546b24d8d08d8b8.mirror.swr.myhuaweicloud.com'
    else
        DOCKER_CE_MIRRORS='https://download.docker.com'
        DOCKER_MIRRORS='https://docker.io'
    fi

    # Trust Docker's GPG Public Key
    curl -fsSL ${DOCKER_CE_MIRRORS}/linux/ubuntu/gpg | apt-key add -

    # Add Software Repositories
    echo "deb [arch=$(dpkg --print-architecture)] ${DOCKER_CE_MIRRORS}/linux/ubuntu $(lsb_release -cs) stable" >> /etc/apt/sources.list.d/docker.list

    # Install Docker
    apt-get update
    apt-get install docker-ce docker-ce-cli containerd.io -y

    # Manage Docker as a non-root user
    groupadd docker
    usermod -aG docker "${SUDO_USER}"

    echo "{\"registry-mirrors\":[\"${DOCKER_MIRRORS}\"]}" > /etc/docker/daemon.json

    systemctl restart docker.service
    systemctl enable docker.service

    # Install Docker Compose
    curl -L https://get.daocloud.io/docker/compose/releases/download/v2.2.2/docker-compose-"$(uname -s)"-"$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

    grep "" /etc/apt/sources.list.d/docker.list
    echo
    systemctl status docker.service --no-pager
    echo
    docker-compose --version

    printf '\n%s%s\n%s%s\n\n' "${INFOCOLOR}" \
    "Done, please log out and log back in, then test docker!" \
    "The log of this execution can be found at ${LOGFILE}" \
    "${NOCOLOR}" >&3
}
