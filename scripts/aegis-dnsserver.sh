#!/bin/bash
#
# aegis-dnsserver.sh - Change DNS server (Cloud servers automatically obtain exclusive configurations).
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

function aegis_dnsserver()
{
    info_msg '\n%s\n' "[${STATS}] Change DNS server (Cloud servers automatically obtain exclusive configurations)"

    local SET_DNSSERVER

    if [ "${DNS_SERVER}" != '119.29.29.29' ]; then
        SET_DNSSERVER=${DNS_SERVER}
    elif [ -n "$(wget -qO- -t1 -T2 169.254.0.23)" ]; then
        # Tencent Cloud
        SET_DNSSERVER='183.60.83.19 183.60.82.98'
    elif [ -n "$(wget -qO- -t1 -T2 100.100.100.200)" ]; then
        # Alibaba Cloud
        SET_DNSSERVER='100.100.2.136 100.100.2.138'
    elif [ -n "$(wget -qO- -t1 -T2 169.254.169.254)" ]; then
        # HUAWEI Cloud
        SET_DNSSERVER='100.125.1.250'
    else
        SET_DNSSERVER='119.29.29.29'
    fi

    sed -i "s/^#DNS=.*/DNS=${SET_DNSSERVER}/" /etc/systemd/resolved.conf
    sed -i "s/^#FallbackDNS=.*/FallbackDNS=119.29.29.29/" /etc/systemd/resolved.conf
    sed -i "s/^#DNSSEC=.*/DNSSEC=allow-downgrade/" /etc/systemd/resolved.conf
    sed -i "s/^#DNSOverTLS=.*/DNSOverTLS=opportunistic/" /etc/systemd/resolved.conf

    systemctl restart systemd-resolved
    systemctl enable systemd-resolved

    rm -rf /etc/resolv.conf
    ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

    if [[ $VERIFY == "Y" ]]; then
        grep -Ev '^#|^$' /etc/resolv.conf | uniq
        echo
        grep -Ev '^#|^$' /etc/systemd/resolved.conf | uniq
    else
        succ_msg '%s\n' "Success, this operation is complete!"
    fi

    sleep 1

    ((STATS++))
}
