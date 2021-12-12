#!/bin/bash
#
# aegis-logindefs.sh - Optimize login.defs policy.
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

function aegis_logindefs()
{
    info_msg '\n%s\n' "[${STATS}] Optimize login.defs policy"

    # umask 077 will make the system more secure, but may cause some problems.
    # sed -i 's/^UMASK.*/UMASK 077/' /etc/login.defs

    sed -i 's/^.*LOG_OK_LOGINS.*/LOG_OK_LOGINS yes/' /etc/login.defs
    # Password can be used for a maximum of 30 days.
    sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 60/' /etc/login.defs
    # 1 day between password changes.
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 1/' /etc/login.defs
    # Warning 7 days before password expiration.
    sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE 7/' /etc/login.defs
    # Disable login for users without home directory.
    sed -i 's/DEFAULT_HOME.*/DEFAULT_HOME no/' /etc/login.defs
    # Set the system default encryption algorithm to SHA512.
    sed -i 's/ENCRYPT_METHOD.*/ENCRYPT_METHOD SHA512/' /etc/login.defs
    # Disable synchronous deletion of user groups when deleting users.
    sed -i 's/USERGROUPS_ENAB.*/USERGROUPS_ENAB no/' /etc/login.defs

    sed -i 's@^ENV_SUPATH.*@ENV_SUPATH PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin@' /etc/login.defs
    sed -i 's@^ENV_PATH.*@ENV_PATH PATH=/usr/local/bin:/usr/bin:/bin:/snap/bin@' /etc/login.defs

    if [[ $VERIFY == "Y" ]]; then
        grep -Ev '^#|^$' /etc/login.defs | uniq
    else
        succ_msg '%s\n' "Success, this operation is complete!"
    fi

    sleep 1

    ((STATS++))
}
