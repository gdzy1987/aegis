#!/bin/bash
#
# aegis-ntpserver.sh - Change NTP Server (Cloud servers automatically obtain exclusive configurations).
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

function aegis_ntpserver()
{
    info_msg '\n%s\n' "[${STATS}] Change NTP Server (Cloud servers automatically obtain exclusive configurations)"

    systemctl stop systemd-timesyncd
    systemctl mask systemd-timesyncd

    apt-get purge ntp -y >/dev/null 2>&1

    apt-get install chrony -y >/dev/null 2>&1
    cp ./config/chrony.conf /etc/chrony/chrony.conf

    local SET_NTPSERVER

    if [ "${NTP_SERVER}" != 'time1.cloud.tencent.com time2.cloud.tencent.com time3.cloud.tencent.com time4.cloud.tencent.com time5.cloud.tencent.com' ]; then
        SET_NTPSERVER=${NTP_SERVER}
    elif [ -n "$(wget -qO- -t1 -T2 169.254.0.23)" ]; then
        # Tencent Cloud
        SET_NTPSERVER='time1.tencentyun.com time2.tencentyun.com time3.tencentyun.com time4.tencentyun.com time5.tencentyun.com'
    elif [ -n "$(wget -qO- -t1 -T2 100.100.100.200)" ]; then
        # Alibaba Cloud
        SET_NTPSERVER='ntp1.cloud.aliyuncs.com ntp2.cloud.aliyuncs.com ntp3.cloud.aliyuncs.com ntp4.cloud.aliyuncs.com ntp5.cloud.aliyuncs.com'
    elif [ -n "$(wget -qO- -t1 -T2 169.254.169.254)" ]; then
        # HUAWEI Cloud
        SET_NTPSERVER='ntp.myhuaweicloud.com'
    else
        SET_NTPSERVER='time1.cloud.tencent.com time2.cloud.tencent.com time3.cloud.tencent.com time4.cloud.tencent.com time5.cloud.tencent.com'
    fi

    local SERVER

    for SERVER in ${SET_NTPSERVER}; do
        echo "server ${SERVER} iburst" >> /etc/chrony/chrony.conf
    done

    systemctl restart chrony.service

    if [[ $VERIFY == "Y" ]]; then
        grep -Ev '^#|^$' /etc/chrony/chrony.conf | uniq
        echo
        systemctl status systemd-timesyncd --no-pager
        echo
        timedatectl status
        echo
        chronyc sources
    else
        succ_msg '%s\n' "Success, this operation is complete!"
    fi

    sleep 1

    ((STATS++))
}
