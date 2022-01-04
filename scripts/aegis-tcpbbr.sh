#!/bin/bash
#
# aegis-tcpbbr.sh - Enable TCP BBR.
# Seaton Jiang <hi@seatonjiang.com>
#
# The latest version of Aegis can be found at:
# https://github.com/seatonjiang/aegis
#
# Copyright (C) 2021-2022 Seaton Jiang
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

function aegis_tcpbbr()
{
    info_msg '\n%s\n' "[${STATS}] Enable TCP BBR"

    if ! sysctl net.ipv4.tcp_available_congestion_control | grep -q bbr; then
        {
            echo -e '\n# Controls the use of TCP BBR'
            echo "net.core.default_qdisc=fq"
            echo "net.ipv4.tcp_congestion_control=bbr"
        } >> /etc/sysctl.conf
        sysctl -p >/dev/null 2>&1
    fi

    if [[ $VERIFY == "Y" ]]; then
        sysctl net.ipv4.tcp_available_congestion_control
        echo
        lsmod | grep bbr
    else
        succ_msg '%s\n' "Success, this operation is complete!"
    fi

    sleep 1

    ((STATS++))
}
