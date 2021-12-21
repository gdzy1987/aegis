#!/bin/bash
#
# aegis-fdisk.sh - Interactive mount data disk.
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

# shellcheck disable=SC2001
# shellcheck disable=SC2010
# shellcheck disable=SC2143
function aegis_fdisk()
{
    info_msg '\n%s\n' "[1] Show all active disks"
    fdisk -l | grep -o "Disk /dev/.*vd[b-z]"

    info_msg '\n%s' "[2] Choose the disk [e.g. /dev/vdb]: "
    while :; do
        read -r DISK
        if [ -z "$(echo "${DISK}" | grep '^/dev/.*vd[b-z]')" ]; then
            error_msg '%s' "Format error, please try again: "
        else
            if [ -z "$(fdisk -l | grep -o "Disk /dev/.*vd[b-z]" | grep "${DISK}")" ]; then
                error_msg '%s' "No disk found, please try again: "
            else
                fdisk_mounted
                break
            fi
        fi
    done

    info_msg '\n%s\n' "[3] Partitioning and formatting the disk"
    fdisk_mkfs "${DISK}" >/dev/null 2>&1
    succ_msg '%s\n' "Success, the disk has been partitioned and formatted!"

    info_msg '\n%s' "[4] Location of disk mounts [Default: /data]: "
    while :; do
        read -r MOUNT
        MOUNT=${MOUNT:-"/data"}
        if [ -z "$(echo "${MOUNT}" | grep '^/')" ]; then
            error_msg '%s' "Directory must begin with /, please try again: "
        else
            mkdir "${MOUNT}" >/dev/null 2>&1
            mount "${DISK}1" "${MOUNT}"
            break
        fi
    done
    succ_msg '%s\n' "Success, the mount is completed!"

    info_msg '\n%s\n' "[5] Write the config to /etc/fstab and mount the device"
    if [ -n "$(wget -qO- -t1 -T2 169.254.0.23)" ]; then
        SDISK=$(echo "${DISK}" | grep -o "/dev/.*vd[b-z]" | awk -F"/" '{print $(NF)}')
        SOFTLINK=$(ls -l /dev/disk/by-id | grep "${SDISK}1" | awk -F" " '{print $(NF-2)}')
        sed -i "/${SOFTLINK}/d" /etc/fstab
        echo "/dev/disk/by-id/${SOFTLINK} ${MOUNT} ext4 defaults 0 2" >> /etc/fstab
    else
        sed -i "/${DISK}1/d" /etc/fstab
        echo "${DISK}1 ${MOUNT} ext4 defaults 0 2" >> /etc/fstab
    fi
    succ_msg '%s\n' "Success, the /etc/fstab has been written!"

    info_msg '\n%s\n' "[6] Show the amount of free disk space on the system"
    df -Th

    info_msg '\n%s\n' "[7] Show the configuration file for /etc/fstab"
    grep -Ev '^#|^$' /etc/fstab | uniq
}

function fdisk_mounted()
{
    while mount | grep -q "${DISK}";do
        error_msg '\n%s\n' "This disk has been mounted"
        mount | grep "${DISK}"
        error_msg '\n%s' "Force Unloading the disk? [y/n]: "
        while :; do
        read -r UMOUNT
        if [[ ! "${UMOUNT}" =~ ^[y,n,Y,N]$ ]]; then
            error_msg '%s' "Format error, please try again: "
        else
            if [ "${UMOUNT}" == 'y' ] || [ "${UMOUNT}" == 'Y' ]; then
                for i in $(mount | grep "${DISK}" | awk '{print $3}');do
                    fuser -km "$i"
                    umount "$i"
                    TEMP=$(echo "${DISK}" | sed 's;/;\\\/;g')
                    sed -i -e "/^$TEMP/d" /etc/fstab
                done
                succ_msg '%s\n' "Success, the disk is unloaded!"
            else
                exit
            fi
            break
        fi
        done
        error_msg '\n%s' "Ready to format the disk? [y/n]: "
        while :; do
        read -r CHOICE
        if [[ ! "${CHOICE}" =~ ^[y,n,Y,N]$ ]]; then
            error_msg '%s' "Format error, please try again: "
        else
            if [ "${CHOICE}" == 'y' ] || [ "${CHOICE}" == 'Y' ]; then
                dd if=/dev/zero of="${DISK}" bs=512 count=1 >/dev/null 2>&1
                sync
                succ_msg '%s\n' "Success, the disk has been formatted!"
            else
                exit
            fi
            break
        fi
        done
    done
}

function fdisk_mkfs()
{
    fdisk "$1" << EOF
n
p
1


wq
EOF

    sleep 3
    partprobe
    mkfs -t ext4 "${1}1"
}
