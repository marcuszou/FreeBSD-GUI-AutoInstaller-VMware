# FreeBSD 14 - Install GUI Methods



Once you install the FreeBSD 14 on a bare-bone style, you have to do something extra for having a GUI handy.



## Pre-requisites

1. Install some necessary packages with `root` user as a starter.

   ```
   pkg update && pkg upgrade
   pkg install bash nano sudo curl wget git neofetch
   ```
   
   
   
2. Apart from the `root` user, we will create a common user, say `alfazen`, and add the user into `wheel`, `operator` and `video` group during creation, also change the shell to `bash`. password? I use `unxP@ss1`.

   ```
   adduser
   ```

   

3. Add user to `wheel`, `video` and `operator` groups if we forget to do so in previous step:

   ```
   pw groupmod wheel -m alfazen
   pw groupmod video -m alfazen
   pw groupmod operator -m alfazen
   ```

   

4. Add the common user to `sudoers` group by editing `/usr/local/etc/sudoers`:

   ```
   ## User privilege specification
   alfazen ALL=(ALL:ALL) ALL
   ```

   and optionally **uncomment** the following 3 rows:

   ```
   # %wheel ALL=(ALL:ALL) ALL
   # %wheel ALL=(ALL:ALL) NOPASSWD: ALL
   # %sudo ALL=(ALL:ALL) ALL 
   ```

   

5. Exit the `root` user and login as the Common User (say, `alfazen`) :

   ```bash
   echo $SHELL
   ```

   

## Method 1 - Run the script from GitHub repo to install



Clone the GitHub repo and give a go:

```
git clone https://github.com/marcuszou/FreeBSD-DeskEnv-AutoInstaller-VMware.git
cd FreeBSD-DeskEnv-AutoInstaller-VMware

sudo bash ./kde-install.sh
```

Then reboot and log in as the Common User:

```
reboot
```



## Method 2 - Install via `desktop-installer` package



This is a very easy but multiple-steps method.

Login as `root` user and Install the `desktop-installer`, the all-powerful package to manage the installation of a GUI for FreeBSD.

```
pkg install desktop-installer
pkg py39-gdbm py39-sqlite3 py39-tkinter

dekstop-installer
```



... Select the "Essential setting"

... it will ask to reboot to apply the update, please do so.

... Then it may ask you to test the DE, please do so.

... Done!



## Method 3 - Manually Install



1. Update the pkg repository to `latest` to install the most recent version of Xfce:

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

   

2. Install the graphics card driver, since we are in VMware, instead of Intel/AMD/Nvidia, we have to install `open-vm-tools` and related graphics card drivers.

   ```
   pkg install open-vm-tools xf86-video-vmware xf86-input-vmmouse
   ```

   This is very long process as it will download quite some packages from Internet.

   

3. Install `kde5`. This will provide a full-range KDE5 Desktop Environment.

   ```
   pkg install xorg kde5 firefox
   ```

   

4. Configure xorg to load the vmware mouse driver:

   ```bash
   # if you haven't installed xorg yet make the directory first
   sudo mkdir -p /usr/local/etc/X11/xorg.conf.d/
   sudo vi /usr/local/etc/X11/xorg.conf.d/vmware.conf
   ```

   Include the following configuration:

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

   

5. A few Configurations

   * Configure `/etc/fstab` by adding:

     ```
     proc	/proc	procfs	rw	0	0
     ```
     
   * Configure the `/etc/rc.conf` by injecting the following lines as below:

     ```
     sudo sysrc dbus_enable="YES"
     sudo sysrc moused_enable="YES"
     ```
     
   * Configure the kernel video output mode to `vt`:

     ```
     sudo bash -c "echo kern.vty=vt >> /boot/loader.conf"
     ```

   

11. NOW to install the Desktop Manager: `sddm` - Simple Desktop Display Manager and `plasma5-sddm-kcm` - the sddm Configurator:

    ```bash
    pkg install sddm plasma5-sddm-kcm
    ```

    


12. Then inject the configuration into `/etc/rc.conf` by:

    ```bash
    sysrc sddm_enable="YES"
    ```



13. Optional - Some VMware Desktop Environment default to a display size that is way bigger than your screen. To correct this, create a `xrand`r script that will be executed by `sddm` to establish the correct display size. Example: `/usr/local/etc/sddm/sddm-xrandr`:

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



11. Reboot and login with the installed Desktop Display Manager.




## Trouble-shooting

#### - Missing taskbar and menu bar when logging into Xfce Desktop

This happens sometimes, especially when the system was just installed. That's due to corrupt session sticking around, and the system cannot auto-remove it. then remove it manually:

```
rm -rf ~/.cache/sessions
```

Sometimes, a few reboots will resolve the issue.



#### - In some cases, the sound in the VM chirps

then need to fix the Audio card driver.

* Need to change the `FreeBSD.vmx` file by adding:

  ```
  sound.present = "TRUE"
  sound.autoDetect = "TRUE"
  sound.allowGuestConnectionControl = "false"
  sound.virtualDev = "hdaudio"
  sound.fileName = "-1"
  ```

* Then start the FreeBSD VM, login as the Common user and update the `/etc/rc.conf` by adding the following lines:

  ```
  # Audio card driver
  sound_load="YES"
  snd_hda_load="YES"
  ```

  