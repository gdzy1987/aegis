#!/bin/bash
#
# aegis-apport.sh - Disable Apport service.
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

function aegis_apport()
{
    info_msg '\n%s\n' "[${STATS}] Disable Apport service"

    if [ -f /etc/default/apport ]; then
        sed -i 's/enabled=.*/enabled=0/' /etc/default/apport
        systemctl stop apport.service
        systemctl mask apport.service >/dev/null 2>&1
    fi

    if [[ $VERIFY == "Y" ]]; then
        systemctl status apport.service --no-pager
    else
        succ_msg '%s\n' "Success, the operation has been completed!"
    fi

    sleep 1

    ((STATS++))
}
