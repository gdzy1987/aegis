#!/bin/bash
#
# aegis-hostname.sh - Change system hostname (Cloud servers automatically obtain exclusive configurations).
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

function aegis_hostname()
{
    info_msg '\n%s\n' "[${STATS}] Change system hostname (Cloud servers automatically obtain exclusive configurations)"

    local SET_HOSTNAME

    if [ "${HOSTNAME}" != 'Ubuntu-Server' ]; then
        SET_HOSTNAME=${HOSTNAME}
    elif [ -n "$(wget -qO- -t1 -T2 169.254.0.23)" ]; then
        # Tencent Cloud
        SET_HOSTNAME=$(wget -qO- -t1 -T2 169.254.0.23/latest/meta-data/instance-name)
    elif [ -n "$(wget -qO- -t1 -T2 100.100.100.200)" ]; then
        # Alibaba Cloud
        SET_HOSTNAME=$(wget -qO- -t1 -T2 100.100.100.200/latest/meta-data/hostname)
    elif [ -n "$(wget -qO- -t1 -T2 169.254.169.254)" ]; then
        # HUAWEI Cloud
        SET_HOSTNAME=$(wget -qO- -t1 -T2 169.254.169.254/latest/meta-data/hostname)
    else
        SET_HOSTNAME="Ubuntu-Server"
    fi

    OLD_HOSTNAME=$(hostname)

    hostnamectl set-hostname --static "${SET_HOSTNAME}"
    sed -i "s@${OLD_HOSTNAME}@${SET_HOSTNAME}@g" /etc/hosts
    sed -i '/update_hostname/d' /etc/cloud/cloud.cfg

    if [[ $VERIFY == "Y" ]]; then
        grep -Ev '^#|^$' /etc/hosts | uniq
    else
        succ_msg '%s\n' "Success, this operation is complete!"
    fi

    sleep 1

    ((STATS++))
}
