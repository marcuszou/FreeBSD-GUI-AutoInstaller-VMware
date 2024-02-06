# FreeBSD 14 - Install Apps through Ports



Once FreeBSD 14 is installed in place, you may think about grabbing some apps. The regular way is to acquire those apps through `pkg install` which brings up quite some server-based apps, but you have to turn to ports collection if needing more and extra.



First thing first, setup the ports system in your FreeBSD 14.



## 1A- Setup Ports System: Git Method



1. This method downloads a full backup of https://git.freebsd.org/ports.git, that's too much for disk space. Any how, Check out a copy of the HEAD branch of the ports tree if your hard disk enjoys that challenge!

   ```
   # switch to su mode
   su -
   
   # engage the linux package and start the service
   sysrc linux_enable="YES" && service linux start
   
   pkg install git
   mkdir -p /usr/ports
   
   git clone https://git.FreeBSD.org/ports.git /usr/ports
   ```

   

2. As needed, update `/usr/ports` after the initial Git checkout:

   ```
   git -C /usr/ports pull
   ```

   This takes quite some time since it bring down the entire tree of the git repo.



## 1B- Setup Ports System: PortSnap Method (Preferred)



1. To begin installing ports on our FreeBSD system, we must first download the *Ports Collection*. 

   ```
   # switch to su mode
   su -
   
   # engage the linux package and start the service
   sysrc linux_enable="YES" && service linux start
   
   mkdir -p /usr/ports
   
   pkg install portsnap
   ```

   

2. Then copy the configuration file over.

   ```
   cp /usr/local/etc/portsnap.conf.sample /usr/local/etc/portsnap.conf
   ```

   

3. The following command will download the latest compressed snapshot of the Ports Collection (around 105MB as of 6 Feb 2024) and extract it into the `/usr/ports` directory:

   ```
   portsnap fetch extract
   ```

   Later on, if we want to update our snapshot of the Ports Collection, we can run:

   ```
   portsnap fetch update
   ```




## 2- Navigating the Ports Collection



Now that the Ports Collection has been installed, we need to be able to find applications that we want to install on our system. The Ports Collection contains directories for software categories, and inside each category are subdirectories for individual applications. We will determine the relevant information necessary to navigate to the `tigervnc` port.

- Visit the official [FreeBSD ports website](https://www.freebsd.org/ports/) and click on “Listed by Logical Group” in the sidebar on the left. Here, we can browse the list of applications available as ports in each category. We can also search for applications using the highlighted search bar.

- Navigate to the application’s directory in the Ports Collection, substituting in the category name and package name you noted earlier in the format of `cd /usr/ports/CATEGORY_NAME/PACKAGE_NAME`.

- Now that we are inside the directory for the `net/tigervnc` port, we can begin understanding the installation process. This application directory, called the *port skeleton*, contains a set of files that tells FreeBSD how to compile and install the program. Each port skeleton includes these files and directories:

  - `Makefile`: contains statements that specify how the application should be compiled and where its components should be installed.
  - `distinfo`: contains the names and checksums of the files that must be downloaded to build the port.
  - `files/`: this directory contains any patches needed for the program to compile and install on FreeBSD. This directory may also contain other files used to build the port.
  - `pkg-descr`: provides a more detailed description of the program.
  - `pkg-plist`: a list of all the files that will be installed by the port. It also tells the ports system which files to remove upon deinstallation.

  **NOTE:** The port does not include the actual source code, also known as a `distfile`. The “extract” portion the build process will automatically download and save the compressed source code in the `/usr/ports/distfiles` directory.

  

## 3- Installing the Port



To install the port (and clean the directory to remove any temporary files afterward), type:

```
# switch to common user
cd /usr/ports/net/tigervnc

make install clean
```



## 4- Removing the Port

Installed ports can be uninstalled using `pkg delete`. Examples for using this command can be found in the [pkg-delete(8)](https://man.freebsd.org/cgi/man.cgi?query=pkg-delete&sektion=8&format=html) manual page.

Alternately, `make deinstall` can be run in the port's directory:

```
cd /usr/ports/sysutils/lsof
make deinstall
```



## 5- Ports and Disk Space

Using the Ports Collection will use up disk space over time. After building and installing a port, running `make clean` within the ports skeleton will clean up the temporary `work` directory. If `Portmaster` is used to install a port, it will automatically remove this directory unless `-K` is specified. If `Portupgrade` is installed, this command will remove all `work` directories found within the local copy of the Ports Collection:

```
portsclean -C
```

In addition, outdated source distribution files accumulate in `/usr/ports/distfiles` over time. To use Portupgrade to delete all the `distfiles` that are no longer referenced by any ports:

```
portsclean -D
```

Portupgrade can remove all `distfiles` not referenced by any port currently installed on the system:

```
portsclean -DD
```

If `Portmaster` is installed, use:

```
portmaster --clean-distfiles
```



