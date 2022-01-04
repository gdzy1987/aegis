#!/bin/bash
#
# aegis-limits.sh - Optimize ulimit for high concurrency situations.
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

function aegis_limits()
{
    info_msg '\n%s\n' "[${STATS}] Optimize ulimit for high concurrency situations"

    if ! grep -qnri "# Aegis Limits Config" /etc/security/limits.conf; then
        sed -i 's/^# End of file*//' /etc/security/limits.conf
        {
            echo '# Aegis Limits Config'
            echo '* soft nofile 655350'
            echo '* hard nofile 655350'
            echo '* soft nproc  unlimited'
            echo '* hard nproc  unlimited'
            echo '* soft core   unlimited'
            echo '* hard core   unlimited'
        } >> /etc/security/limits.conf
    fi

    if [[ $VERIFY == "Y" ]]; then
        grep -Ev '^#|^$' /etc/security/limits.conf | uniq
    else
        succ_msg '%s\n' "Success, this operation is complete!"
    fi

    sleep 1

    ((STATS++))
}
