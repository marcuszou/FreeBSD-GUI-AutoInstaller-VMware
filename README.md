# FreeBSD Desktop Environment AutoInstaller on Vmware

A guide to install the **Xfce4** Desktop Environment on **FreeBSD 14.0-RELEASE** running as a guest operating system on VMware (tested on VMware Fusion 13.5.0, Workstation 17.5.0). This guide includes configuration files and an optional configuration script.

![xfce4-freebsd.jpg](resources/Freebsd14-Xfce4.png)



## Pre-Requisites

* FreeBSD installed as a guest operating system on VMware.

  * AMD64-ISOs: [FreeBSD-14.0-RELEASE](https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/14.0/)
  * AMD64-VMs: [FreeBSD-14.0-VM-IMAGES](https://download.freebsd.org/releases/VM-IMAGES/14.0-RELEASE/amd64/Latest/)

* Installation of a few package:

  ```
  pkg install bash nano sudo curl wget git neofetch  
  ```

* Create a common user `alfazen`, adding into groups of `wheel`, `video`.

* modify `/usr/local/etc/sudoers` :

  ```
  alfazen ALL=(ALL:ALL) ALL
  ```

* Also check the shell version

  ```
  echo $SHELL
  ```

  

Note: Hardware acceleration doesn't currently work with FreeBSD on VMware. The driver was [removed](https://github.com/freebsd/drm-kmod/commit/ff9d303c7ea85cd8627d0a3dc0dbccceefd30687)



## Login as a Common User and Run the commands below

```bash
git clone https://github.com/marcuszou/FreeBSD-DeskEnv-AutoInstaller-VMware.git
cd FreeBSD-DeskEnv-AutoInstaller-VMware
sudo bash ./xfce-autoinstall.bash
```

If the Common User is in sh, the last command shall be:

```sh
sudo sh ./xfce-autoinstall.sh
```



## Reboot and Login

Nothing special but enjoyable experiences



## More Documents

[FreeBSD14-AutoInstall-Xfce4-Methods](FreeBSD14-AutoInstall-Xfce4-Methods.md)



##### The end
