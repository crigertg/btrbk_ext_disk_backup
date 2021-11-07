#!/bin/bash

set -e
set -x

# the first given argument will be interpreted as path to file containing variables
# if not set it defaults to ./btrbk_external_disk.vars
SOURCEFILE="${1}"
source "${SOURCEFILE:=./btrbk_external_disk.vars}"

[ -z "${BACKUP_DISK_UUID}" ] && echo 'Unset BACKUP_DISK_UUID' && exit 1
[ -z "${LUKS_KEYFILE}" ] && echo 'Unset LUKS_KEYFILE' && exit 1
[ -z "${MOUNT_DIR}" ] && echo 'Unset MOUNT_DIR' && exit 1

source ./btrbk_external_functions.sh

mount_encrypted_backup_disk "${BACKUP_DISK_UUID}" "${LUKS_KEYFILE}" "${MOUNT_DIR}"
sudo btrbk -c ./btrbk.conf -v run
sudo btrfs balance start -dusage=50 -dlimit=4 -musage=50 -mlimit=2 "${MOUNT_DIR}"
sudo btrfs filesystem df "${MOUNT_DIR}"
sudo btrfs scrub start -B "${MOUNT_DIR}"
umount_encrypted_backup_disk "${MOUNT_DIR}"
