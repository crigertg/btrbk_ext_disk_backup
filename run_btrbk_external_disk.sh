#!/bin/bash

set -e
set -x

# the first given argument will be interpreted as path to file containing variables
# if not set it defaults to ./btrbk_external_disk.vars
SOURCEFILE="${1}"
source "${SOURCEFILE:=./btrbk_external_disk.vars}"

[ -z "${BACKUP_DISK_UUID}" ] && echo 'Unset BACKUP_DISK_UUID' && exit 1
[ -z "${LUKS_KEYFILE}" ] && echo 'Unset LUKS_KEYFILE' && exit 1

source ./btrbk_external_functions.sh

mount_encrypted_backup_disk "${BACKUP_DISK_UUID}" "${LUKS_KEYFILE}" "${MOUNT_DIR}"
sudo btrbk -c ./btrbk.conf -v run
sudo btrfs balance start -dusage=50 -dlimit=4 -musage=50 -mlimit=2 /mnt/btr_backup
sudo btrfs filesystem df "${MOUNT_DIR}"
sudo btrfs scrub start -B /mnt/btr_backup
umount_encrypted_backup_disk "${MOUNT_DIR}"
