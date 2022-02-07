#!/bin/bash
#
# aegis-debugshell.sh - Disable debug-shell service.
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

function aegis_debugshell()
{
    info_msg '\n%s\n' "[${STATS}] Disable debug-shell service"

    systemctl stop debug-shell.service
    systemctl mask debug-shell.service >/dev/null 2>&1

    if [[ $VERIFY == "Y" ]]; then
        systemctl status debug-shell.service --no-pager
    else
        succ_msg '%s\n' "Success, this operation is completed!"
    fi

    sleep 1

    ((STATS++))
}
