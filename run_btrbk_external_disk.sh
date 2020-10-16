#!/bin/bash

set -e
set -x

# the first given argument will be interpreted as path to file containing variables
# if not set it defaults to ./btrbk_external_disk.vars
SOURCEFILE="${1}"
source "${SOURCEFILE:=./btrbk_external_disk.vars}"

[ -z "${BACKUP_DISK_UUID}" ] && echo 'Unset BACKUP_DISK_UUID' && exit 1
[ -z "${LUKS_KEYFILE}" ] && echo 'Unset LUKS_KEYFILE' && exit 1

sudo cryptsetup luksOpen /dev/disk/by-uuid/"${BACKUP_DISK_UUID}" btr_backup --key-file "${LUKS_KEYFILE}"
sudo mkdir -p /mnt/btr_backup
sudo mount /dev/mapper/btr_backup /mnt/btr_backup

sudo btrbk -c ./btrbk.conf -v run

sync
sleep 5
sudo umount /mnt/btr_backup
sleep 5
sudo cryptsetup luksClose btr_backup


