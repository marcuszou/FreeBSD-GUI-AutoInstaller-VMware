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

## install the packages
pkg install -y \
    open-vm-tools \
    xf86-video-vmware \
    xf86-input-vmmouse \
    xf86-input-keyboard \
    xfce \
    lightdm \
    lightdm-gtk-greeter \
    xrandr \
    firefox \

## update rc.conf
sysrc sshd_enable="YES"
sysrc dbus_enable="YES"
sysrc moused_enable="YES"
sysrc lightdm_enable="YES"
sysrc linux_enable="YES"

## update /boot/loader.conf
bash -c "echo kern.vty=vt >> /boot/loader.conf"

## Inject proc to /etc/fstab
bash -c "echo 'proc    /proc    procfs  rw  0  0' >> /etc/fstab"

## install .xinitrc
bash -c  'echo "exec /usr/local/bin/startxfce4 --with-ck-launch" > /home/$SUDO_USER/.xinitrc'

echo 
echo reboot and log in with the common user
echo
