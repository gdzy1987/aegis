#!/bin/bash
#
# aegis-ctrlaltdel.sh - Disable Ctrl-Alt-Delete.
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

function aegis_ctrlaltdel()
{
    info_msg '\n%s\n' "[${STATS}] Disable Ctrl-Alt-Delete"

    systemctl stop ctrl-alt-del.target
    systemctl mask ctrl-alt-del.target >/dev/null 2>&1
    sed -i 's/^#CtrlAltDelBurstAction=.*/CtrlAltDelBurstAction=none/' /etc/systemd/system.conf

    if [[ $VERIFY == "Y" ]]; then
        systemctl status ctrl-alt-del.target --no-pager
        echo
        grep CtrlAltDelBurstAction /etc/systemd/system.conf
    else
        succ_msg '%s\n' "Success, this operation is completed!"
    fi

    sleep 1

    ((STATS++))
}
