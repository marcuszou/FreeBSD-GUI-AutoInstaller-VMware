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



## 6- Browsers

This section describes how to install and configure some popular web browsers on a FreeBSD system, from full web browsers with high resource consumption to command line web browsers with reduced resource usage.

| Name                 | License          | Package                                                      | Resources Needed |
| :------------------- | :--------------- | :----------------------------------------------------------- | :--------------- |
| Firefox              | MPL 2.0          | [www/firefox](https://cgit.freebsd.org/ports/tree/www/firefox/) | Heavy            |
| Chromium             | BSD-3 and others | [www/chromium](https://cgit.freebsd.org/ports/tree/www/chromium/) | Heavy            |
| Iridium browser      | BSD-3 and others | [www/iridium-browser](https://cgit.freebsd.org/ports/tree/www/iridium-browser/) | Heavy            |
| Falkon               | MPL 2.0          | [www/falkon-qtonly](https://cgit.freebsd.org/ports/tree/www/falkon-qtonly/) | Heavy            |
| Konqueror            | GPL 2.0 or later | [x11-fm/konqueror](https://cgit.freebsd.org/ports/tree/x11-fm/konqueror/) | Medium           |
| Gnome Web (Epiphany) | GPL 3.0 or later | [www/epiphany](https://cgit.freebsd.org/ports/tree/www/epiphany/) | Medium           |
| qutebrowser          | GPL 3.0 or later | [www/qutebrowser](https://cgit.freebsd.org/ports/tree/www/qutebrowser/) | Medium           |
| Dillo                | GPL 3.0 or later | [www/dillo2](https://cgit.freebsd.org/ports/tree/www/dillo2/) | Light            |
| Links                | GPL 2.0 or later | [www/links](https://cgit.freebsd.org/ports/tree/www/links/)  | Light            |
| w3m                  | MIT              | [www/w3m](https://cgit.freebsd.org/ports/tree/www/w3m/)      | Light            |

How to Install them:

```
# pkg install firefox
# pkg install chromium
# pkg install iridium-browser
# pkg install falkon
# pkg install konqueror
# pkg install epiphany
# pkg install qutebrowser
# pkg install dillo2
# pkg install links
# pkg install w3m
```



## 7- Development Tools

This section describes how to install and configure some popular development tools on a FreeBSD system.

| Name               | License                                | Package                                                      | Resources Needed |
| :----------------- | :------------------------------------- | :----------------------------------------------------------- | :--------------- |
| Visual Studio Code | MIT                                    | [editors/vscode](https://cgit.freebsd.org/ports/tree/editors/vscode/) | Heavy            |
| Qt Creator         | QtGPL                                  | [devel/qtcreator](https://cgit.freebsd.org/ports/tree/devel/qtcreator/) | Heavy            |
| Kdevelop           | GPL 2.0 or later and LGPL 2.0 or later | [devel/kdevelop](https://cgit.freebsd.org/ports/tree/devel/kdevelop/) | Heavy            |
| Eclipse IDE        | EPL                                    | [java/eclipse](https://cgit.freebsd.org/ports/tree/java/eclipse/) | Heavy            |
| Vim                | VIM                                    | [editors/vim](https://cgit.freebsd.org/ports/tree/editors/vim/) | Light            |
| Neovim             | Apache 2.0                             | [editors/neovim](https://cgit.freebsd.org/ports/tree/editors/neovim/) | Light            |
| GNU Emacs          | GPL 3.0 or later                       | [editors/emacs](https://cgit.freebsd.org/ports/tree/editors/emacs/) | Light            |

How to install them:

```
# pkg install vscode
# pkg install qtcreator
# pkg install kdevelop
# pkg install eclipse
# pkg install vim
# pkg install neovim
# pkg install emacs
```



## 8- Desktop Office Productivity

When it comes to productivity, users often look for an office suite or an easy-to-use word processor. While some desktop environments like [KDE Plasma](https://docs.freebsd.org/en/books/handbook/desktop/#kde-environment) provide an office suite, there is no default productivity package. Several office suites and graphical word processors are available for FreeBSD, regardless of the installed desktop environments.

This section demonstrates how to install the following popular productivity software and indicates if the application is resource-heavy, takes time to compile from ports, or has any major dependencies.

| Name           | License          | Package                                                      | Resources Needed |
| :------------- | :--------------- | :----------------------------------------------------------- | :--------------- |
| LibreOffice    | MPL 2.0          | [editors/libreoffice](https://cgit.freebsd.org/ports/tree/editors/libreoffice/) | Heavy            |
| Calligra Suite | LGPL and GPL     | [editors/calligra](https://cgit.freebsd.org/ports/tree/editors/calligra/) | Medium           |
| AbiWord        | GPL 2.0 or later | [editors/abiword](https://cgit.freebsd.org/ports/tree/editors/abiword/) | Medium           |

To install them, execute:

```
# pkg install libreoffice
# pkg install calligra
# pkg install abiword
```



## 9- Document Viewers

Some new document formats have gained popularity since the advent of UNIX® and the viewers they require may not be available in the base system. This section demonstrates how to install the following document viewers:

| Name     | License | Package                                                      | Resources Needed |
| :------- | :------ | :----------------------------------------------------------- | :--------------- |
| Okular   | GPL 2.0 | [graphics/okular](https://cgit.freebsd.org/ports/tree/graphics/okular/) | Heavy            |
| Evince   | GPL 2.0 | [graphics/evince](https://cgit.freebsd.org/ports/tree/graphics/evince/) | Medium           |
| ePDFView | GPL 2.0 | [graphics/epdfview](https://cgit.freebsd.org/ports/tree/graphics/epdfview/) | Medium           |
| Xpdf     | GPL 2.0 | [graphics/xpdf](https://cgit.freebsd.org/ports/tree/graphics/xpdf/) | light            |
| Zathura  | Zlib    | [graphics/zathura](https://cgit.freebsd.org/ports/tree/graphics/zathura/) | light            |

To install them, execute:

```
# pkg install okular
# pkg install evince
# pkg install epdfview
# pkg install xpdf
# pkg install zathura zathura-pdf-mupdf
```



## 10- Finance

For managing personal finances on a FreeBSD desktop, some powerful and easy-to-use applications can be installed. Some are compatible with widespread file formats, such as the formats used by Quicken and Excel.

This section covers these programs:

| Name     | License             | Package                                                      | Resources Needed |
| :------- | :------------------ | :----------------------------------------------------------- | :--------------- |
| KMyMoney | GPL 2.0             | [finance/kmymoney](https://cgit.freebsd.org/ports/tree/finance/kmymoney/) | Heavy            |
| GnuCash  | GPL 2.0 and GPL 3.0 | [finance/gnucash](https://cgit.freebsd.org/ports/tree/finance/gnucash/) | Heavy            |

To install them, execute:

```
# pkg install kmymoney
```

```
# pkg install gnucash
```
