# FreeBSD Xfce4 on VMware AutoInstaller

A guide to install the **Xfce4** Desktop Environment on **FreeBSD 14.0-RELEASE** running as a guest operating system on VMware (tested on VMware Fusion 13.5.0, Workstation 17.5.0). This guide includes configuration files and an optional configuration script.

![xfce4-freebsd.jpg](resources/xfce4-freebsd.jpg)



## Pre-Requisites

* FreeBSD installed as a guest operating system on VMware.

  * [FreeBSD-14.0-RELEASE](https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/14.0/)
  * [FreeBSD-13.2-RELEASE](https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/13.2/)

* Installation of a few package:

  ```
  pkg install bash nano sudo curl wget git neofetch  
  ```

* Create a common user `alfazen`, adding into groups of `wheel`, `video`.

* modify `/usr/local/etc/sudoers` :

  ```
  alfazen ALL=(ALL:ALL) ALL
  ```

Note: Hardware acceleration doesn't currently work with FreeBSD on VMware. The driver was [removed](https://github.com/freebsd/drm-kmod/commit/ff9d303c7ea85cd8627d0a3dc0dbccceefd30687)



## Login as a Common User and Run the commands below

```bash
git clone https://github.com/marcuszou/FreeBSD-Xfce4-Autoinstaller-VMware.git
cd FreeBSD-Xfce4-Autoinstaller-VMware
sudo ./xfce-install.sh
```



## Manually install Xfce 4.18 and required packages

Update the pkg repository to `latest` to install the most recent version of Xfce:

```bash
sudo mkdir -p /usr/local/etc/pkg/repos
sudo vi /usr/local/etc/pkg/repos/FreeBSD.conf
```

Add the following to `FreeBSD.conf` and run `pkg update`:

```bash
FreeBSD: {
  url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest"
}
```

When you run `pkg -vv` you should see the following:

```bash
Repositories:
  FreeBSD: {
    url             : "pkg+http://pkg.FreeBSD.org/FreeBSD:14:amd64/latest",
    enabled         : yes,
    priority        : 0,
    mirror_type     : "SRV",
    signature_type  : "FINGERPRINTS",
    fingerprints    : "/usr/share/keys/pkg"
  }
```

Install `xorg` `open-vm-tools` and needed drivers:

```bash
sudo pkg install xorg open-vm-tools xf86-video-vmware xf86-input-vmmouse
```

Install Xfce (Meta-port for the Xfce Desktop Environment). This will provide a minimal Xfce Desktop Environement

```bash
sudo pkg install xfce
```

For a more complete desktop install the following additional packages to include Xfce plugins, office software, document viewer and browser:

```bash
sudo pkg install xfce4-goodies libreoffice atril firefox
```

Configure xorg to load the vmware mouse driver:

```bash
# if you haven't installed xorg yet make the directory first
sudo mkdir -p /usr/local/etc/X11/xorg.conf.d/
sudo vi /usr/local/etc/X11/xorg.conf.d/vmware.conf
```

Inclue the following configuration:

```bash
Section "ServerFlags"
       Option             "AutoAddDevices"       "false"
EndSection
Section "InputDevice"
       Identifier    "Mouse0"
       Driver        "vmmouse"
       Option        "Device"       "/dev/sysmouse"
EndSection
```

Ass your username to the video group:

```bash
sudo pw groupmod video -m $USER
sudo pw groupmod wheel -m $USER
```

Update `rc.conf` to start `dbus` and `moused`:

```bash
sudo sysrc dbus_enable="YES"
sudo sysrc moused_enable="YES"
```

Configure the kernel video output mode to `vt`:

```bash
sudo sh -c "echo kern.vty=vt >> /boot/loader.conf"
```

At this point you can start xfce with `startx` or install lightdm. For startx create an .xinitrc and reboot:

```bash
echo "exec /usr/local/bin/startxfce4 --with-ck-launch" > ~/.xinitrc
```

For lightdm install:

```bash
sudo pkg install lightdm lightdm-gtk-greeter
```

Update `rc.conf` to start lightdm:

```bash
sudo sysrc lightdm_enable="YES"
```

Optional - VMware Lightdm DE defaults to a display size that is way bigger than your screen. To correct this, create a `xrand`r script that will be executed by lightdm to establish the correct display size. Example: `/usr/local/etc/lightdm/lightdm-xrandr`:

```bash
#! /usr/local/bin/bash
xrandr --output default --primary --mode 1600x900
```

Now update `/usr/local/etc/lightdm/lightdm.conf`:

```bash
display-setup-script=/usr/local/etc/lightdm/lightdm-xrandr
```

To enable autologin add to `lightdm.conf`:

```bash
autologin-user=alfazen
```

Reboot.
