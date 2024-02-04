# FreeBSD 14 - Install Xfce4 GUI



Once you install the FreeBSD 14 on a bare-bone style (created a common user named as "`marcus`", you have to do something extra for having a GUI handy.



## Method 1 - Auto-installer

1. Install some necessary packages with `root` user as a starter.

   ```
   pkg update && pkg upgrade
   pkg install bash nano sudo curl wget git neofetch
   ```
   
   
   
2. Apart from the `root` user, we will create a common user, say `alfazen`, and add the user into `wheel` and `video` group during creation. password? it's normally `unxP@ss1`.

   ```
   adduser
   ```

   

3. Add user to `wheel`, `video` groups if we forget to do so in previous step:

   ```
   pw groupmod wheel -m alfazen
   pw groupmod video -m alfazen
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

   ```
   exit
   ```

   

6. Run the script below:

   ```
   git clone https://github.com/marcuszou/FreeBSD-Xfce4-AutoInstaller-Vmware.git
   cd FreeBSD-Xfce4-AutoInstaller-VMware
   sudo bash ./xfce-install.sh # if the user is in bash
   # sudo ./xfce-install.sh # if the user is in sh
   ```

   

7. Reboot and log into the Common User with LightDM GUI:

   ```
   reboot
   ```



## Method 2 - install `desktop-installer`

Step 1-4 are exactly same as Method 1.

Step 5 - Login as `root` and Install the `desktop-installer`, the all-powerful package to manage the installation of a GUI for FreeBSD.

```
pkg install desktop-installer
pkg py39-gdbm py39-sqlite3 py39-tkinter ## Optional

dekstop-installer
```



... Select the "Essential setting"

... it will ask to reboot to apply the update, please do so.

... Then it may ask you to test the DE, please so do.

... Done!



## Method 3 - Manual-installer



1. Install some dependencies as `root`

   ```
   pkg update && pkg upgrade
   pkg install bash nano sudo curl wget git neofetch
   ```

2. Apart from the `root` user, we will create a common user, say `alfazen`, and add the user into `wheel` and `video` group during creation. password? it's normally `betaPa$$5o46`.

   ```
   adduser
   ```

3. Add user to `wheel`, `video` groups if we forget to do so in previous step:

   ```
   pw groupmod wheel -m alfazen
   pw groupmod video -m alfazen
   ```

4. Add the common user to `sudoers` group by editing `/usr/local/etc/sudoers`:

   ```
   marcus ALL=(ALL:ALL) ALL
   ```

   

5. Update the pkg repository to `latest` to install the most recent version of Xfce:

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

   

6. Install `xorg` firstly, then the graphics card driver, since we are in VMware, instead of Intel/AMD/Nvidia, we have to install `open-vm-tools` and related graphics card drivers.

   ```
   pkg install xorg
   ## Graphics card drivers
   pkg install open-vm-tools xf86-video-vmware xf86-input-vmmouse
   ```

   This is very long process as it will download quite some packages from Internet.

   

7. Install `Xfce`. This will provide a minimal Xfce Desktop Environment.

   ```
   pkg install xfce
   ```

   

8. (OPTIONAL) For a more complete desktop install the following additional packages to include `Xfce` plugins, document viewer and browser:

   ```
   pkg install xfce4-goodies atril firefox
   ```

   

9. Configure xorg to load the vmware mouse driver:

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

   

10. A few Configurations

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

   

11. NOW to install the Desktop Manager: `lightdm`

    ```
    pkg install lightdm lightdm-gtk-greeter
    ```

    Then inject the configuration into `/etc/rc.conf` by:

    ```
    sysrc lightdm_enable="YES" && service lightdm start
    ```

    

    Note: A second method to start XFCE is by manually invoking [startx(1)](https://man.freebsd.org/cgi/man.cgi?query=startx&sektion=1&format=html). For this to work, the following line is needed in `~/.xinitrc`:

    ```
    % echo '. /usr/local/etc/xdg/xfce4/xinitrc' > ~/.xinitrc
    ```

    

12. Optional - VMware Lightdm DE defaults to a display size that is way bigger than your screen. To correct this, create a `xrand`r script that will be executed by lightdm to establish the correct display size. Example: `/usr/local/etc/lightdm/lightdm-xrandr`:

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

    

13. Reboot and login with LightDM.




## Trouble-shooting

#### - Missing taskbar and menu bar when logging into Xfce Desktop

This happens sometimes, especially when the system was just installed. That's due to corrupt session sticking around, and the system cannot auto-remove it. then remove it manually:

```
rm -rf ~/.cache/sessions
```



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

  