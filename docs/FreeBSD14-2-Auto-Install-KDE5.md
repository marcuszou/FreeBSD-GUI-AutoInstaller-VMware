# FreeBSD 14 - Install KDE5



Once you install the FreeBSD 14 on a bare-bone style, you have to do something extra for having a GUI handy.



1. Install some dependencies

   ```
   pkg update && pkg upgrade
   pkg install bash nano sudo git curl wget neofetch
   ```

   

2. If there is only a `root` user, please create a common user, say `alfazen`, and add the user into `wheel`, `video` and `operator` groups during creation (DM me for default password).

   ```
   adduser
   ```

   

3. Optionally add the common user to `wheel`, `video`, `operator` groups if forgetting to join such in previous step:

   ```
   pw groupmod video -m alfazen
   pw groupmod wheel -m alfazen
   pw groupmod operator -m alfazen
   ```

   

4. Add the common user to `sudoers` group by editing `/usr/local/etc/sudoers`:

   ```
   ## User privilege specification
   alfazen ALL=(ALL:ALL) ALL
   ```

   and uncomment the 3 lines:

   ```
   # %wheel ALL=(ALL:ALL) ALL
   # %wheel ALL=(ALL:ALL) NOPASSWD: ALL
   # %sudo ALL=(ALL:ALL) ALL 
   ```

   

5. Install graphics card driver of VMware or Nvidia, or AMD, or Intel.

   ```
   ## For Vmware
   pkg install open-vm-tools xf86-video-vmware xf86-input-vmmouse xf86-input-keyboard
   ```

   

6. Install KDE Plasma meta package (`kde5`), a full set of apps, plus the Simple Desktop Display Manager (`sddm`), the SDDM Module Configurator (`plasma5-sddm-kcm`), and a typical web browser (`firefox`).

   ```
   ## KDE5 packages
   pkg install -y xorg kde5 sddm plasma5-sddm-kcm
   ```

   This is very long process as it will download quite some packages from Internet.

   

   Alternatively install a minimal KDE Plasma (`plasma5-plasma`), plus a few supporting modules:

   ```
   pkg install -y xorg plasma5-plasma sddm plasma5-sddm-kcm firefox konsole
   ```

   

7. A few Configuration

   * Configure the `/etc/sysctl.conf` by injecting the following rows (`sysctl` command does not work):

     ```
     bash -c "echo 'net.local.stream.sendspace=65536' >> /etc/sysctl.conf"
     bash -c "echo 'net.local.stream.recvspace=65536' >> /etc/sysctl.conf"
     ```
     
   * Configure the `/etc/rc.conf` by injecting the following:

     ```
     sysrc sshd_enable="YES"
     sysrc dbus_enable="YES"
     sysrc sddm_enable="YES"
     sysrc moused_enable="YES"
     sysrc linux_enable="YES"
     ```
     
   * Optionally configure the `/etc/fstab` by adding in the following row:

     ```
     bash -c "echo 'proc    /proc    procfs  rw  0  0' >> /etc/fstab"
     ```
     
   * Then reboot the computer and log back in at a GUI.

     ```
     reboot
     ```

   

   