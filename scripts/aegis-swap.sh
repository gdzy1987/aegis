#!/bin/bash
#
# aegis-swap.sh - Add swap space.
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

function aegis_swap()
{
    info_msg '\n%s\n' "[${STATS}] Add swap space"

    MEM=$(free -m | awk '/Mem:/{print $2}')

    if [ "$MEM" -le 1280 ]; then
        MEM_LEVEL=1G
    elif [ "$MEM" -gt 1280 ] && [ "$MEM" -le 2500 ]; then
        MEM_LEVEL=2G
    elif [ "$MEM" -gt 2500 ] && [ "$MEM" -le 3500 ]; then
        MEM_LEVEL=3G
    elif [ "$MEM" -gt 3500 ] && [ "$MEM" -le 4500 ]; then
        MEM_LEVEL=4G
    elif [ "$MEM" -gt 4500 ] && [ "$MEM" -le  8000 ]; then
        MEM_LEVEL=6G
    elif [ "$MEM" -gt 8000 ]; then
        MEM_LEVEL=8G
    fi

    if [ "$(free -m | awk '/Swap:/{print $2}')" == '0' ]; then
        fallocate -l "${MEM_LEVEL}" /swapfile

        chmod 600 /swapfile
        mkswap /swapfile >/dev/null 2>&1
        swapon /swapfile

        sed -i "/swap/d" /etc/fstab
        echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
    fi

    if ! sysctl -p | grep -q vm.swappiness; then
        {
            echo -e '\n# Setting the vm.swappiness'
            echo "vm.swappiness=10"
        } >> /etc/sysctl.conf
    else
        sed -i "s/^vm.swappiness=.*/vm.swappiness=10/" /etc/sysctl.conf
    fi

    if ! sysctl -p | grep -q vm.vfs_cache_pressure; then
        {
            echo -e '\n# Setting the vm.vfs_cache_pressure'
            echo "vm.vfs_cache_pressure=50"
        } >> /etc/sysctl.conf
    else
        sed -i "s/^vm.vfs_cache_pressure=.*/vm.vfs_cache_pressure=50/" /etc/sysctl.conf
    fi

    sysctl -p >/dev/null 2>&1

    if [[ $VERIFY == "Y" ]]; then
        swapon --show
        echo
        free -h
        echo
        grep -Ev '^#|^$' /etc/fstab | uniq
    else
        succ_msg '%s\n' "Success, this operation is complete!"
    fi

    sleep 1

    ((STATS++))
}
