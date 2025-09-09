#!/bin/bash
# Auto-mount & unmount USB drives on Raspberry Pi for Nextcloud
# Supports exFAT and other FS types, mounts to /media/usbdrive

usage() {
    echo "Usage: $0 {add|remove} device_name (e.g. sda1)"
    exit 1
}

if [[ $# -ne 2 ]]; then
    usage
fi

ACTION=$1
DEVBASE=$2
DEVICE="/dev/${DEVBASE}"
MOUNT_POINT=$(/bin/mount | /bin/grep ${DEVICE} | /usr/bin/awk '{ print $3 }')

do_mount() {
    if [[ -n ${MOUNT_POINT} ]]; then
        echo "Warning: ${DEVICE} is already mounted at ${MOUNT_POINT}"
        exit 0
    fi

    eval $(/sbin/blkid -o udev ${DEVICE})
    MOUNT_POINT="/media/usbdrive"
    /bin/mkdir -p ${MOUNT_POINT}
    OPTS="uid=33,gid=33,umask=007"

    if [[ ${ID_FS_TYPE} == "exfat" ]]; then
        FS_TYPE="exfat"
    else
        FS_TYPE="${ID_FS_TYPE}"
    fi

    if ! /bin/mount -t ${FS_TYPE} -o ${OPTS} ${DEVICE} ${MOUNT_POINT}; then
        /bin/rmdir ${MOUNT_POINT}
        exit 1
    fi
    echo "Mounted ${DEVICE} at ${MOUNT_POINT}"
}

do_unmount() {
    if [[ -z ${MOUNT_POINT} ]]; then
        echo "Warning: ${DEVICE} is not mounted"
    else
        /bin/umount -l ${DEVICE}
        echo "Unmounted ${DEVICE}"
    fi

    for f in /media/*; do
        if [[ -n $(/usr/bin/find "$f" -maxdepth 0 -type d -empty) ]]; then
            if ! /bin/grep -q " $f " /etc/mtab; then
                /bin/rmdir "$f"
            fi
        fi
    done
}

case "${ACTION}" in
    add) do_mount ;;
    remove) do_unmount ;;
    *) usage ;;
esac
