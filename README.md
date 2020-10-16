# btrfs_ext_disk_backu

I've created this script to mirror local btrfs snapshots via [btrbk](https://github.com/digint/btrbk) to an external disk (for e.g. USB device). 

# preface

This is more like a template and documentation for myself. It's not a complete solution for your backup, bu can be a part of it! You should definitely have some kind of automatic backup!

# setup

In this example the external disk is `/dev/sdb`. Please check with `lsblk` and `dmesg` yourself if you're using the correct device. Please be aware that you will delete all data on the external device if you follow the steps in this tutorial.

1. create a partition on your external disk, for e.g. via `parted`:

   ```
   parted /dev/sdb
   print free
   mklabel GPT
   mkpart primary 0% 100%
   quit
   ```

2. Encrypt the disk via LUKS: 
   
   ```
   sudo cryptsetup luksFormat /dev/sdb1
   ```
   
3. Create a Keyfile for LUKS
   
   ```
   sudo dd if=/dev/urandom of=/crypto_keyfile.bin bs=1024 count=4
   ```
   
4. update permissions for the keyfile:
   
   ```
   sudo chmod 400 /crypto_keyfile.bin
   ```
   
5. add the keyfile to the LUKS device:
   
   ```
   sudo cryptsetup luksAddKey /dev/sdX /root/keyfile 
   ```
   
6. The `btrbk.conf` assumes that you have mounted your local `btrfs` partition with all suvolumes in `/mnt/btr_pool` and have a subvolume `@snapshots` in it. I backup my `@` and `@home` subvolumes, you may need to change this in the `btrbk.conf`. The dir should look like this:

   ```
   $ ls /mnt/btr_pool/
   @  @cache  @home  @snapshots  timeshift-btrfs
   ```
   
   The entry in /etc/fstab could look like this:

   ```
   # /dev/mapper/manjaro-root all subvolumes for btrbk
   UUID=78fa5e8c-dc17-4f58-bada-00c1f3e935f3	/mnt/btr_pool         	btrfs     	rw,noatime,compress=zstd:3,ssd,space_cache,commit=120	0 0
   ```
   
7. now you need to to a `btrbk_external_disk.vars` file. You can copy the `btrbk_external_disk.vars.example` file.
   
   - To get the `BACKUP_DISK_UUID` use `lsblk -f` which will show your blockdevices with their corresponding UUIDs.
   - Check if you need the path to your keyfile and update `LUKS_KEYFILE`.
   
8. If the devices and the path is present you should be able to run `bash run_btrbk_external_disk.sh`

# running your backup

I regularly attach my USB disk to my notebook and run the script manually. It's possible to create a `udev` rule for it to automate the process. You need to set the path to the file containing the variables via the first argument of the shellscript, for e.g.: `bash run_btrbk_external_disk.sh /home/foo/backup/btrbk_external_disk.vars`.

Please be aware that you should always check if the backup runs as expected. You could add a email output or use `notify-send`. 

# restore / restore test 

Please refer to the README of [btrbk](https://github.com/digint/btrbk). You should test you backups from time to time.
