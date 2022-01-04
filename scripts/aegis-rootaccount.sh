#!/bin/bash
#
# aegis-rootaccount.sh - Disable root account.
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

function aegis_rootaccount()
{
    info_msg '\n%s\n' "[${STATS}] Disable root account"

    usermod -L root

    if [[ $VERIFY == "Y" ]]; then
        passwd -S root
    else
        succ_msg '%s\n' "Success, this operation is complete!"
    fi

    sleep 1

    ((STATS++))
}
