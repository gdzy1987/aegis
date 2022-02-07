#!/bin/bash
#
# aegis-removeagent.sh - Remove cloud server agent.
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

function aegis_removeagent()
{
    info_msg '\n%s\n' "Remove cloud server agent"

    if [ -n "$(wget -qO- -t1 -T2 169.254.0.23)" ]; then
        # Tencent Cloud
        /usr/local/qcloud/monitor/barad/admin/uninstall.sh >/dev/null 2>&1

        /usr/local/qcloud/stargate/admin/uninstall.sh >/dev/null 2>&1

        /usr/local/qcloud/YunJing/uninst.sh >/dev/null 2>&1

        mkdir -p /tmp/tat_agent/uninstall
        wget -O /tmp/tat_agent/uninstall/tat_agent.zip https://tat-gz-1258344699.cos.ap-guangzhou.myqcloud.com/tat_agent_linux_x86_64.zip >/dev/null 2>&1
        unzip -o /tmp/tat_agent/uninstall/tat_agent.zip -d /tmp/tat_agent/uninstall/ >/dev/null 2>&1
        /tmp/tat_agent/uninstall/uninstall.sh >/dev/null 2>&1
        rm -rf /tmp/tat_agent/
    fi

    succ_msg '%s\n' "Success, the operation has been completed!"
}
