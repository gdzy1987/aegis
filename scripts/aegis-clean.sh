#!/bin/bash
#
# aegis-clear.sh - Clear all system logs, cache and backup files.
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

function aegis_clear()
{
    info_msg '\n%s\n' "Clear all system logs, cache and backup files"

    # /var/log/
    find /var/log -type f -regex ".*\.[0-9]$" -delete
    find /var/log -type f -regex ".*\.gz$" -delete

    while IFS= read -r -d '' logfile
    do
        cp /dev/null "${logfile}"
    done < <(find /var/log/ -type f ! -name 'aegis-*' -print0)

    # /var/log/journal/
    rm -rf /var/log/journal/*
    systemctl restart systemd-journald.service

    # /var/cache/fontconfig/
    find /var/cache/fontconfig -type f -delete

    # /var/backups/
    find /var/backups -type f -delete

    apt-get autoclean -y
    apt-get autoremove -y

    succ_msg '%s\n' "Success, this operation is complete!"
}
