#!/bin/bash
#
# aegis-motd.sh - Optimize motd (Disable the default motd and add a new motd).
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

function aegis_motd()
{
    info_msg '\n%s\n' "[${STATS}] Optimize motd (Disable the default motd and add a new motd)"

    # Disable motd-news
    sed -i 's/ENABLED=.*/ENABLED=0/' /etc/default/motd-news
    systemctl stop motd-news.timer
    systemctl mask motd-news.timer >/dev/null 2>&1
    chmod -x /etc/update-motd.d/50-motd-news

    # Disable defualt motd
    chmod -x /etc/update-motd.d/00-header
    chmod -x /etc/update-motd.d/10-help-text
    chmod -x /etc/update-motd.d/50-landscape-sysinfo

    # Add new motd
    cp ./config/00-aegis-header /etc/update-motd.d/00-aegis-header
    cp ./config/10-aegis-system-info /etc/update-motd.d/10-aegis-system-info
    cp ./config/11-aegis-disk-usage /etc/update-motd.d/11-aegis-disk-usage
    cp ./config/12-aegis-docker-status /etc/update-motd.d/12-aegis-docker-status
    cp ./config/20-aegis-footer /etc/update-motd.d/20-aegis-footer
    chmod +x /etc/update-motd.d/*-aegis-*

    if [[ "${PROD_TIPS}" =~ ^['N','n']$ ]]; then
        chmod -x /etc/update-motd.d/20-aegis-footer
    fi

    if [[ $VERIFY == "Y" ]]; then
        systemctl status motd-news.timer --no-pager
    else
        succ_msg '%s\n' "Success, this operation is completed!"
    fi

    sleep 1

    ((STATS++))
}
