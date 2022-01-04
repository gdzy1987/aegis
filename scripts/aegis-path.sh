#!/bin/bash
#
# aegis-path.sh - Optimize paths (For users with root and normal privileges).
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

function aegis_path()
{
    info_msg '\n%s\n' "[${STATS}] Optimize paths (For users with root and normal privileges)"

    sed -i 's/PATH=.*/PATH=\"\/usr\/local\/bin:\/usr\/bin:\/bin:\/snap\/bin"/' /etc/environment
    cp ./config/aegis-bin-path.sh /etc/profile.d/aegis-bin-path.sh
    chown root:root /etc/profile.d/aegis-bin-path.sh
    chmod 0644 /etc/profile.d/aegis-bin-path.sh

    if [[ $VERIFY == "Y" ]]; then
        cat /etc/environment
    else
        succ_msg '%s\n' "Success, this operation is complete!"
    fi

    sleep 1

    ((STATS++))
}
