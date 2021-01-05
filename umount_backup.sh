#!/bin/bash

set -e
set -x

SOURCEFILE="${1}"
source "${SOURCEFILE:=./btrbk_external_disk.vars}"
source ./btrbk_external_functions.sh

umount_encrypted_backup_disk "${MOUNT_DIR}"
