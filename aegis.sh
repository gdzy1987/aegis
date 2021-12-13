#!/bin/bash
#
# Aegis - System security hardening tool for Ubuntu Server.
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

export LC_ALL=C.UTF-8

set -u -o pipefail

# Check account.
if (( EUID != 0 )); then
    printf '%s\n' "$(tput setaf 1)Error: Aegis requires an account with root privileges. Try using 'sudo bash ${0}'.$(tput sgr0)" >&2
    exit 1
fi

# Check Ubuntu.
if ! grep -Eqi "Ubuntu" /etc/issue; then
    printf '%s\n' "$(tput setaf 1)Error: Aegis is only available for Ubuntu systems.$(tput sgr0)" >&2
    exit 1
fi

# Check bash.
# shellcheck disable=SC2009
if ! ps -p $$ | grep -siq bash; then
    printf '%s\n' "$(tput setaf 1)Error: Aegis needs to be run with bash.$(tput sgr0)" >&2
    exit 1
fi

# Aegis tool version.
AEGIS_VER='1.0'

# Path to logfile.
LOGFILE=/var/log/aegis-$(date +%Y%m%d-%s).log

# Create log file.
truncate -s0 "${LOGFILE}"

# Send all output to the logfile as well as stdout.
# Output to 1 goes to stdout and the logfile.
# Output to 2 goes to stderr and the logfile.
# Output to 3 just goes to stdout.
# Output to 4 just goes to stderr.
# Output to 5 just goes to the logfile.
# shellcheck disable=SC2094
exec \
    3>&1 \
    4>&2 \
    5>> "${LOGFILE}" \
    > >(tee -a "${LOGFILE}") \
    2> >(tee -a "${LOGFILE}" >&2)

# List nocolor last here so that -x doesn't bork the display.
SUCCOCOLOR=$(tput setaf 2)
INFOCOLOR=$(tput setaf 6)
NOCOLOR=$(tput sgr0)

# Single arg just gets returned verbatim, multi arg gets formatted via printf.
# First arg is the name of a variable to store the results.
function msg_format()
{
    local _VAR
    _VAR="$1"
    shift
    if (( $# > 1 )); then
        # shellcheck disable=SC2059
        printf -v "${_VAR}" "$@"
    else
        printf -v "${_VAR}" "%s" "$1"
    fi
}

# Send an info message to the log file and stdout.
function info_msg()
{
    local MSG
    msg_format MSG "$@"
    printf '%s' "${MSG}" >&5
    printf '%s%s%s' "${INFOCOLOR}" "${MSG}" "${NOCOLOR}" >&3
}

# Send an success message to the log file and stdout.
function succ_msg()
{
    local MSG
    msg_format MSG "$@"
    printf '%s' "${MSG}" >&5
    printf '%s%s%s' "${SUCCOCOLOR}" "${MSG}" "${NOCOLOR}" >&3
}

# shellcheck disable=SC1091
source aegis.conf

# shellcheck disable=SC1090
for SCRIPTS in scripts/aegis-*.sh; do
    [[ -f ${SCRIPTS} ]] || break
    source "${SCRIPTS}"
done

# shellcheck disable=SC2034
function aegis_banner()
{
    info_msg '%s\n'   '    ___              _         ______            __          '
    info_msg '%s\n'   '   /   | ___  ____ _(_)____   /_  __/___  ____  / /          '
    info_msg '%s\n'   '  / /| |/ _ \/ __ `/ / ___/    / / / __ \/ __ \/ /           '
    info_msg '%s\n'   ' / ___ /  __/ /_/ / (__  )    / / / /_/ / /_/ / /            '
    info_msg '%s\n'   '/_/  |_\___/\__, /_/____/    /_/  \____/\____/_/             '
    info_msg '%s\n\n' '           /____/                                            '
    info_msg '%s\n'   'Please read the instructions carefully before use.           '
    info_msg '%s\n\n' 'If a problem is encountered, please provide the log file.    '
    info_msg '%s\n'   '• Mail bug reports     : hi@seatonjiang.com                  '
    info_msg '%s\n'   '• Follow me on Weibo   : https://weibo.com/seatonjiang       '
    info_msg '%s\n'   '• For more information : https://github.com/seatonjiang/aegis'
    sleep 1
    STATS=1
}

function aegis_help()
{
    echo -e "\nUsage:  $0 [--version] [--help]"
    echo -e "Where:  --version     Print version and exit."
    echo -e "        --help        Print help and exit."
    echo -e "\nMail bug reports or suggestions to <hi@seatonjiang.com>."
}

function aegis_version()
{
    echo -e "Aegis version ${AEGIS_VER}"
}

function aegis_reboot()
{
    printf '\n%s%s\n%s%s\n\n' "${INFOCOLOR}" \
    "Done, please reboot your system." \
    "The log of this execution can be found at ${LOGFILE}" \
    "${NOCOLOR}" >&3
    exit 0
}

function aegis_main()
{
    clear
    aegis_banner
    aegis_dnsserver
    aegis_ntpserver
    aegis_hostname
    aegis_timezone
    aegis_timeout
    aegis_sshdconfig
    aegis_useradd
    aegis_motd
    aegis_limits
    aegis_path
    aegis_usersandgroup
    aegis_logindefs
    aegis_tcpbbr
    aegis_apport
    aegis_debugshell
    aegis_ctrlaltdel
    aegis_rootaccount
    aegis_removepackages
    aegis_reboot
}

if [ $# -eq 0 ];then
    aegis_main
fi

while :; do
    [ -z "$1" ] && exit 0;
    case $1 in
        --version)
            aegis_version
            exit 0
        ;;
        --help)
            aegis_version
            aegis_help
            exit 0
        ;;
        *)
            echo -e "Invalid option: $1"
            echo -e "Usage: $0 [--version] [--help]"
            echo -e "\nUse \"$0 --help\" for complete list of options"
            exit 1
        ;;
    esac
done
