#!/usr/bin/env bash

## configure and install minimal xfce desktop environment on vmware

## check for sudo/root
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo, try again..."
  exit 1
fi

## update pkg repo to 'latest' and update
mkdir -p /usr/local/etc/pkg/repos
bash -c "cat ./resources/FreeBSD.conf >> /usr/local/etc/pkg/repos/FreeBSD.conf"
pkg update

## install vmware.conf to enable vmware mouse
mkdir -p /usr/local/etc/X11/xorg.conf.d/
bash -c "cat ./resources/vmware.conf >> /usr/local/etc/X11/xorg.conf.d/vmware.conf"

## add username to video group
pw groupmod video -m $SUDO_USER
pw groupmod wheel -m $SUDO_USER
pw groupmod operator -m $SUDO_USER

## pre-make 2 folders for icons
mkdir -p /usr/share/icons/hicolor
mkdir -p /usr/share/icons/HighContrast
## install the packages
pkg install -y \
    open-vm-tools \
    xf86-video-vmware \
    xf86-input-vmmouse \
    xf86-input-keyboard \
    gnome \
    firefox \
    vlc \
    fusefs-ntfs \
    fusefs-exfat \
    fusefs-ext2 \

## update rc.conf and adding more
sysrc sshd_enable="YES"
sysrc dbus_enable="YES"
sysrc moused_enable="YES"
sysrc gdm_enable="YES"
sysrc linux_enable="YES"
sysrc fusefs_enable="YES"
sysrc fusefs_safe="YES"
sysrc fusefs_safe_evil="YES"

## update /boot/loader.conf
bash -c "echo kern.vty=vt >> /boot/loader.conf"
bash -c "echo fusefs_load='YES' >> /boot/loader.conf"
bash -c "echo snd_driver_load='YES' >> /boot/loader.conf"

## Inject proc to /etc/fstab
bash -c "echo 'proc    /proc    procfs  rw  0  0' >> /etc/fstab"
bash -c "echo '.host:/ /mnt/hgfs fusefs rw,mountprog=/usr/local/bin/vmhgfs-fuse,allow_other,failok 0 0' >> /etc/fstab"

echo 
echo reboot and log in with the common user
echo
