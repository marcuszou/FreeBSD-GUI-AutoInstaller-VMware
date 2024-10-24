# FreeBSD 14 - Shared folder from Windows/Linux Host to FreeBSD Guest

by Marcus Zou



When geeks test the functions of FreeBSD 14, quite often, the shared folder from a Windows/Linux host to the FreeBSD guest is a common one to be looked into. There are quite some articles on the cyber space, utilizing the Linux expertise for this case. For instance,

`vmhgfs-fuse`, `mount-vmhgfs`...

But those Linux methods don't work out at all, obviously due to FreeBSD being different from Linux. 

Here are my method, tested to be okay on FreeBSD 14 guest with Windows, Linux as a host.



## 1- Install packages to drive up the file systems of host

For Windows host -

```
sudo pkg install open-vm-tools fusefs-ntfs fusefs-exfat
```

For Linux host -

```
sudo pkg install open-vm-tools fusefs-ext2 fusefs-exfat
```



## 2- Configure the FreeBSD guest

2.1 Configure `/etc/rc.conf` file - adding the following:

```shell
fusefs_enable="YES"
fusefs_safe="YES"
fusefs_safe_evil="YES"
```

2.2 Configure `/boot/loader.conf` file - adding the following:

```
fusefs_load="YES"
# snd_driver_load="YES"
```

You can type in the following command to test on-the-fly without rebooting:

```bash
kldload fusefs
```

2.3 Configure `/etc/fstab` file - adding the following:

```shell
.host:/ /mnt/hgfs fusefs rw,mountprog=/usr/local/bin/vmhgfs-fuse,allow_other,failok 0 0
```



## 3- Reboot the VM guest

You could test the functions as below:

```
# mounting an exfat formatted device:
mount.exfat /dev/da0s1 /mnt/exfat

# mounting a NTFS formatted device:
ntfs-3g /dev/da0s1 /mnt -o rw

# mounting a FAT32 formatted device
mount_msdosfs /dev/da0s1 /mnt
```



## The End

