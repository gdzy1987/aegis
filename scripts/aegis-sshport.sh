#!/bin/bash
#
# aegis-sshport.sh - Modify the SSH port.
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

function aegis_sshport()
{
    if [ ! -e "/etc/ssh/sshd_config" ];then
        error_msg '\n%s\n' "Error: Can't find sshd config file!"
        exit 1
    fi

    OLD_SSH_PORT=$( grep ^Port /etc/ssh/sshd_config | awk '{print $2}' | head -1 )

    info_msg '\n%s' "[1/2] Please enter SSH port (Range of 10000 to 65535, current is ${OLD_SSH_PORT}): "
    while :; do
        read -r NEW_SSH_PORT
        NPTSTATUS=$( netstat -lnp | grep "${NEW_SSH_PORT}" )
        if [ -n "${NPTSTATUS}" ];then
            error_msg '%s' "The port is already occupied, Please try again (Range of 10000 to 65535): "
        elif [ "${NEW_SSH_PORT}" -lt 10000 ] || [ "${NEW_SSH_PORT}" -gt 65535 ];then
            error_msg '%s' "Please try again (Range of 10000 to 65535): "
        else
            break
        fi
    done

    if [[ "${OLD_SSH_PORT}" != "22" ]]; then
        sed -i "s@^Port.*@Port ${NEW_SSH_PORT}@" /etc/ssh/sshd_config
    else
        sed -i "s@^#Port.*@&\nPort ${NEW_SSH_PORT}@" /etc/ssh/sshd_config
        sed -i "s@^Port.*@Port ${NEW_SSH_PORT}@" /etc/ssh/sshd_config
    fi

    succ_msg '%s\n' "Success, the SSH port modification completed!"
    info_msg '\n%s\n' "[2/2] Restart the service to take effect"
    systemctl restart sshd.service >/dev/null 2>&1
    succ_msg '%s\n\n' "Success, if you use elastic compute service, please enable [TCP:${NEW_SSH_PORT}] for the security group!"
}
