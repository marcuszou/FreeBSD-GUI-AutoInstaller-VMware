# FreeBSD 14 - VNC/RDP on FreeBSD



Remote access to a FreeBSD server is a normal and handy operation in server management domain. Then let's give a go with the new FreeBSD 14 Release.



## VNC Servers on FreeBSD 14



There are typical **VNC Servers** on FreeBSD 14:

* xrdp (Works like a charm, the best Remote Access solution ever!)
* TigerVNC Server (Woks great with Xfce4 and KDE5)
* TightVNC (Doesn't work at all)



The **VNC Client/Viewer** can vary: 

* TigerVNC Viewer: Supporting VNC protocol, on Windows, Linux, and macOS.
* Remmina: Supporting RDP, VNC, SSH protocols, on Windows, Linux, and macOS



## Pre-requisites

Assuming you have installed / configured / downloaded the *Ports Collection*. 

```
$ sudo pkg install portsnap
$ sudo cp /usr/local/etc/portsnap.conf.sample /usr/local/etc/portsnap.conf
$ sudo portsnap fetch extract
```



## A- TightVNC (Doesn't Work at all)



Assuming you have installed / configured / downloaded the *Ports Collection*. 

```
$ sudo pkg install portsnap
$ sudo cp /usr/local/etc/portsnap.conf.sample /usr/local/etc/portsnap.conf
$ sudo portsnap fetch extract
```



1. Then install the `TightVNC`.

   ```
   $ cd /usr/ports/net/tightvnc
   $ sudo make install clean
   ```

   It may present minor warnings of compilation, but go ahead.

   > [!TIP]
   >
   > ===>  Installing for tightvnc-1.3.10_9
   > ===>  Checking if tightvnc is already installed
   > ===>   Registering installation for tightvnc-1.3.10_9
   > Installing tightvnc-1.3.10_9...
   > ===> SECURITY REPORT: 
   >       This port has installed the following files which may act as network servers and may therefore pose a remote security risk to the system.
   > /usr/local/bin/Xvnc
   > /usr/local/bin/vncviewer
   >
   > If there are vulnerabilities in these programs there may be a security risk to the system. FreeBSD makes no guarantee about the security of ports included in the Ports Collection. Please type 'make deinstall'  to deinstall the port if this is a concern.
   >
   > For more information, and contact details about the security status of this software, see the following webpage: https://www.tightvnc.com/

   

2. Run the server of FreeBSD, login with a common user:

   ```
   $ vncserver -geometry 1600x900 -depth 24
   ```

   At the first time, It will require a password to access your desktops (please note down this password), then present you with some info:

   > [!TIP]
   >
   > New 'X' desktop is freebsd14:1
   >
   > Starting applications specified in /home/alfazen/.vnc/xstartup
   > Log file is /home/alfazen/.vnc/freebsd14:2.log

   This is good sign of successful installing with `freebsd14` as host and `1` as the port (actually the port is 5901).

   > [!TIP]
   >
   > If you start up a vnc server in a wrong setting, please find the process and kill it.
   >
   > ```
   > ps -aux | grep vnc
   > ```
   >
   > It will display:
   >
   > > alfazen    10116   0.0  0.3  25940  11004  0  I    05:29      0:00.16 Xvnc :1 -desktop X -httpd /usr/local/share/tightvnc/classes -aut
   > > alfazen    14346   0.0  0.0  12796   1952  0  S+   08:50      0:00.00 grep vnc
   >
   > then kill the process #10116:
   >
   > ```
   > kill 10116
   > ```

   

3. Launch a VNC viewer from another computer, say a Windows PC and type in:

   ```
   192.168.86.150:5901 # in the format of serverName:portNumber
   ```

   

4. It may present you a **black screen**. then go back to Server to modify the `~/.vnc/xstartup` file.

   > [!NOTE]
   >
   > ```
   > #!/bin/sh
   > 
   > xrdb "$HOME/.Xresources"
   > xsetroot -solid grey
   > xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
   > twm &
   > ```
   >
   > by default, TightVNC uses `twm` as that is available on most Unix platforms.

   change that `twm` to the `startxfce4` or `startkde` as per your Server's GUI.

   > [!NOTE]
   >
   > ```
   > #!/bin/sh
   > 
   > xrdb "$HOME/.Xresources"
   > xsetroot -solid grey
   > xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
   > startxfce4 &
   > ```

   

5. Repeat Step #3, then you still get a **black screen** at your Windows/Linux/macOS client. Crap TightVNC!

   > [!Note]
   >
   > [Tightsvnc](https://www.freshports.org/net/tightvnc/) expires at the end of March 2023, FreeBSD, as some users claimed to have outdated pkgs, will have barely any functional vnc(-server) port. Yes, there is Vino, TigerVNC, (and other?), but do they really work as servers? TigerVNC-server works on MS Windows though. TightVNC will also remain active on MS Windows after expiration here, like `vncserver`, which have been reused into several commercial products on MS.



Then we have to try TigerVNC.

> [!CAUTION]
>
> Sanity job: Before moving to next testing on TigerVNC Server, please remove the `~/.vnc` folder !!!

```
$ rm -rf ~/.vnc
```




## B- TigerVNC (server and client, works great!)



[TigerVNC Server](https://cgit.freebsd.org/ports/tree/net/tigervnc-server) is probably the fastest VNC offering at the moment. It provides `Xvnc` and `vncserver`. Likewise, the TigerVNC client is also one of the fastest. Here are some messages regarding TigerVNC:

> Whilst it is always good to have different options, it does tend to be superior to TightVNC.

> Have been using it for years as it offers the widest compatibility with even "special" VNC implementations I've encountered e.g. on some old KVM instances or BMC/IPMI variants.

> If you are looking for some form of "remote desktop" solution (i.e. not only for setup/maintenance purposes): Just use X-forwarding or have a look at something like [`x11/xmx`](http://www.freshports.org/x11/xmx).
>

> If there are Windows boxes involved, I'd go for [`deskutils/anydesk`](http://www.freshports.org/deskutils/anydesk). We've been using it at work for ~3 years now and if you have to connect to windows clients on a regular basis, this is far more convenient as it offers e.g. shared buffers or file transfers. RDP is also 'OK-ish' and KRDC works quite nice, but RDP comes with all the stupidities and artificial restrictions like e.g. the remote side goes dark (logs out) when connecting and you can't really keep a session open and share/access it remotely (b/c windows still isn't a real multi-user system by choice...). There are patches that allow multiple concurring RDP-sessions, but this is completely unsupported and brings a lot of other problems - plus it always opens a new session (even for the same user) on reconnect, so it's also worthless...
>



1. To install the port (and clean the directory to remove any temporary files afterward), type:

   ```
   $ cd /usr/ports/net/tigervnc-server
   $ sudo make install clean
   ```

   The installation went well with message below:

   > [!TIP]
   >
   > ===>  Installing for tigervnc-server-1.13.1_3
   > ===>  Checking if tigervnc-server is already installed
   > ===>   Registering installation for tigervnc-server-1.13.1_3
   > Installing tigervnc-server-1.13.1_3...
   > ===> SECURITY REPORT: 
   > This port has installed the following files which may act as network servers and may therefore pose a remote security risk to the system.
   > /usr/local/bin/Xvnc
   > /usr/local/bin/x0vncserver
   > /usr/local/lib/xorg/modules/extensions/libvnc.so
   >
   > If there are vulnerabilities in these programs there may be a security risk to the system. FreeBSD makes no guarantee about the security of ports included in the Ports Collection. Please type 'make deinstall' to deinstall the port if this is a concern.
   >
   > For more information, and contact details about the security status of this software, see the following webpage: https://tigervnc.org/

   

2. Run the server of FreeBSD, login with a common user:

   ```
   $ vncserver -geometry 1600x900 -depth 24
   ```

   At the first time, It will require a password to access your desktops (please note down this password), then present you with some info:

   > [!TIP]
   >
   > New 'freebsd14:1 (alfazen)' desktop is freebsd14:1
   >
   > Creating default startup script /home/alfazen/.vnc/xstartup
   > Creating default config /home/alfazen/.vnc/config
   > Starting applications specified in /home/alfazen/.vnc/xstartup
   > Log file is /home/alfazen/.vnc/freebsd14:1.log

   This is good sign of successful installing with `freebsd14` as host and `1` as the port (actually the port is 5901). Please find the IP address of the host prior to proceed.

   

3. Launch a VNC viewer from another computer, say a Linux/Windows PC and type in:

   ```
   192.168.86.150:5901 # in the format of serverName:portNumber
   ```

4. It may present you a black screen. then go back to Server to modify the `~/.vnc/xstartup` file.

   > [!TIP]
   >
   > ```
   > #!/bin/sh
   > 
   > unset SESSION_MANAGER
   > unset DBUS_SESSION_BUS_ADDRESS
   > OS=`uname -s`
   > if [ $OS = 'Linux' ]; then
   >   case "$WINDOWMANAGER" in
   >     *gnome*)
   >       if [ -e /etc/SuSE-release ]; then
   >         PATH=$PATH:/opt/gnome/bin
   >         export PATH
   >       fi
   >       ;;
   >   esac
   > fi
   > if [ -x /etc/X11/xinit/xinitrc ]; then
   >   exec /etc/X11/xinit/xinitrc
   > fi
   > if [ -f /etc/X11/xinit/xinitrc ]; then
   >   exec sh /etc/X11/xinit/xinitrc
   > fi
   > [ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
   > xsetroot -solid grey
   > xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
   > twm &
   > ```

   by default, TigerVNC server uses `twm` as that is available on most Unix platforms. Then change that `twm` to the `startxfce4` or `startkde` as per your Server's GUI.

   > [!TIP]
   >
   > ```
   > #!/bin/sh
   > 
   > unset SESSION_MANAGER
   > unset DBUS_SESSION_BUS_ADDRESS
   > OS=`uname -s`
   > if [ $OS = 'Linux' ]; then
   >   case "$WINDOWMANAGER" in
   >     *gnome*)
   >       if [ -e /etc/SuSE-release ]; then
   >         PATH=$PATH:/opt/gnome/bin
   >         export PATH
   >       fi
   >       ;;
   >   esac
   > fi
   > if [ -x /etc/X11/xinit/xinitrc ]; then
   >   exec /etc/X11/xinit/xinitrc
   > fi
   > if [ -f /etc/X11/xinit/xinitrc ]; then
   >   exec sh /etc/X11/xinit/xinitrc
   > fi
   > [ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
   > xsetroot -solid grey
   > xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
   > startxfce4 &
   > ```

   

5. Repeat Step #4. 

   Hola! It works - Got the GUI from remote client! 



Let's try XRDP server on FreeBSD.



## C- xrdp 

The procedure is same as what have done in the past.



1. You can install `xrdp` by building from ports, but since there is `xrdp` package, then why bother? so type:

   ```
   $ sudo pkg install xrdp
   ```

   The installation went well with message below:

   > [!TIP]
   >
   > =====
   > Message from xrdp-0.9.24_1,1:
   >
   > --
   > xrdp has been installed.
   >
   > There is an rc.d script, so the service can be enabled by adding this line in **/etc/rc.conf**:
   >
   > **xrdp_enable="YES"**
   > **xrdp_sesman_enable="YES"** # if you want to run xrdp-sesman on the same machine
   >
   > Do not forget to edit the configuration files in "/usr/local/etc/xrdp"
   > and the "**/usr/local/etc/xrdp/startwm.sh**" script.

   

2. Inject the following lines into `/etc/rc.conf`:

   ```
   sudo sysrc xrdp_enable="YES"
   sudo sysrc xrdp_sesman_enable="YES"
   ```

   

3. Configure your Window Manager by editing `/usr/local/etc/xrdp/startwm.sh`:

   ```
   #!/bin/sh
   #
   # This script is an example. Edit this to suit your needs.
   # If ${HOME}/starttwm.sh exists, xrdp-sesman will execute it instead of this.
   
   #### Set env variables
   # export LANG=en_US.UTF-8
   
   #### Start desktop environment
   # exec gnome-session
   # exec mate-session
   # exec start-lumia-desktop
   # exec startkde
   # exec startxfce4
   exec xterm
   ```

   Most likely, this `/usr/local/etc/xrdp/startwm.sh` is attributed as `555`, then you can not edit it at all.

   so change the mode of the file by:

   ```
   $ sudo chmod 755 /usr/local/etc/xrdp/startwm.sh
   ```

   Then modify it to uncomment `# exec startkde` and comment out `exec xterm`. 

   ```
   #### Start desktop environment
   # exec gnome-session
   # exec mate-session
   # exec start-lumia-desktop
   exec startkde
   # exec startxfce4
   # exec xterm
   ```

   Then **reboot the server**.

   

4. Login with RDP client (`RDP` of Windows, or `Remmina` of Linux/macOS), Type in the Common username and password. 
   Hola! You are remotely connected to the FreeBSD server!



## D- Conclusion



* Installation time - `xrdp` is way faster since it gets installed by `pkg install` while `TightVNC` and `TigerVNC-Server` start from scratch.
* Connectivity: `xrdp` needs a little configuration while the rest 2 need a lot of efforts to configure.



All in all, the best solution is `XRDP`!!
