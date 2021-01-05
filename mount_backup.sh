#!/bin/bash

set -e
set -x

SOURCEFILE="${1}"
source "${SOURCEFILE:=./btrbk_external_disk.vars}"
source ./btrbk_external_functions.sh

mount_encrypted_backup_disk "${BACKUP_DISK_UUID}" "${LUKS_KEYFILE}" "${MOUNT_DIR}"
