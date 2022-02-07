#!/bin/bash
#
# aegis-useradd.sh - Optimize useradd policy (New users need to change SHELL manually).
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

function aegis_useradd()
{
    info_msg '\n%s\n' "[${STATS}] Optimize useradd policy (New users need to change SHELL manually)"

    # When creating a new user, login is disabled by default, so
    # use `usermod -s /bin/bash user` to change the shell.
    sed -i 's/SHELL=.*/SHELL=\/bin\/false/' /etc/default/useradd
    sed -i 's/DSHELL=.*/DSHELL=\/bin\/false/' /etc/adduser.conf
    # After 30 days of password expiration, the account will be disabled.
    sed -i 's/^# INACTIVE=.*/INACTIVE=30/' /etc/default/useradd
    # Each created user will be given their own group.
    sed -i 's/USERGROUPS=.*/USERGROUPS=yes/' /etc/adduser.conf
    # The newly created user home directory permissions are changed to 0750.
    sed -i 's/DIR_MODE=.*/DIR_MODE=0750/' /etc/adduser.conf

    local HPATH
    # Modify the permissions of the home directory of the stock user to 0750.
    awk -F ':' '{if($3 >= 1000 && $3 <= 65000) print $6}' /etc/passwd | while read -r HPATH; do
        chmod 0750 "${HPATH}"
    done

    if [[ $VERIFY == "Y" ]]; then
        grep -Ev '^#|^$' /etc/default/useradd | uniq
        echo
        grep -Ev '^#|^$' /etc/adduser.conf | uniq
    else
        succ_msg '%s\n' "Success, the operation has been completed!"
    fi

    sleep 1

    ((STATS++))
}
