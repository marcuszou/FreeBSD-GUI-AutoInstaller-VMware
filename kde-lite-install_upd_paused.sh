#!/usr/bin/env bash

## configure and install minimal xfce desktop environment on vmware

## check for sudo/root
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo, try again..."
  exit 1
fi

## update pkg repo to 'latest' and update
mkdir -p /usr/local/etc/pkg/repos
## temporarily turn off grabbing the pkg repo of 2024-02-01 
## due to its issue of breaking all of Desktop Manager packages (sddm, etc.)
#bash -c "cat ./resources/FreeBSD.conf >> /usr/local/etc/pkg/repos/FreeBSD.conf"
pkg update

## install vmware.conf to enable vmware mouse
mkdir -p /usr/local/etc/X11/xorg.conf.d/
bash -c "cat ./resources/vmware.conf >> /usr/local/etc/X11/xorg.conf.d/vmware.conf"

## add username to video group
pw groupmod video -m $SUDO_USER
pw groupmod wheel -m $SUDO_USER
pw groupmod operator -m $SUDO_USER

## install the packages
pkg install -y \
    open-vm-tools \
    xf86-video-vmware \
    xf86-input-vmmouse \
    xf86-input-keyboard \
    plasma5-plasma \
    sddm \
    plasma5-sddm-kcm \
    konsole \
    xrandr \
    firefox \

## inject sysctl
bash -c "echo 'net.local.stream.sendspace=65536' >> /etc/sysctl.conf"
bash -c "echo 'net.local.stream.recvspace=65536' >> /etc/sysctl.conf"

## update rc.conf and adding more
sysrc sshd_enable="YES"
sysrc dbus_enable="YES"
sysrc moused_enable="YES"
sysrc sddm_enable="YES"
sysrc linux_enable="YES"

## update /boot/loader.conf
bash -c "echo kern.vty=vt >> /boot/loader.conf"

## Inject proc to /etc/fstab
bash -c "echo 'proc    /proc    procfs  rw  0  0' >> /etc/fstab"

## in case of screen resolution going crazy
## establish correct display size
bash -c "echo '#! /usr/local/bin/bash' > /usr/local/etc/sddm/sddm-xrandr"
bash -c "echo 'xrandr --output default --mode 1600x900' >> /usr/local/etc/sddm/sddm-xrandr"
## Update /usr/local/etc/sddm/sddm.conf
bash -c "echo 'display-setup-script=/usr/local/etc/sddm/sddm-xrandr' >> /usr/local/etc/sddm/sddm.conf"
bash -c "echo 'autologin-user=$SUDO_USER' >> /usr/local/etc/sddm/sddm.conf"

echo 
echo reboot and log in with the common user
echo
