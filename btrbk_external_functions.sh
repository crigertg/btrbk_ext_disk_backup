#!/bin/bash

mount_encrypted_backup_disk() {
  BACKUP_DISK_UUID="${1}"
  LUKS_KEYFILE="${2}"
  MOUNT_DIR="${3}"
  sudo cryptsetup luksOpen /dev/disk/by-uuid/"${BACKUP_DISK_UUID}" btr_backup --key-file "${LUKS_KEYFILE}"
  sudo mkdir -p "${MOUNT_DIR}"
  sudo mount /dev/mapper/btr_backup "${MOUNT_DIR}"
}

umount_encrypted_backup_disk() {
  MOUNT_DIR="${1}"
  sync
  sleep 5
  sudo umount "${MOUNT_DIR}"
  sleep 5
  sudo cryptsetup luksClose btr_backup
}
