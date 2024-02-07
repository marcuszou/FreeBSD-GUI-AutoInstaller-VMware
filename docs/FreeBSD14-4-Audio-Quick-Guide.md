# Audio on FreeBSD – Quick Guide

![img](../resources/freebsd-logo-design-12-1024x1024.png)

Whether for music, communication, or notifications, audio is an important feature of many personal computer systems. In a new FreeBSD system, an audio card will need to be configured to process audio files and send them to the connected speakers.

Fortunately, setting up audio on FreeBSD is simple and straightforward. This guide will walk through setting up and configuring audio, connecting a pair of headphones (including pairing Bluetooth models), and testing the system’s sound, all in under 10 minutes!



## 1. Setting Up the Sound Card

------

FreeBSD supports a wide variety of sound cards, these are listed in the [Hardware Compatability List](https://www.freebsd.org/releases/) for each FreeBSD release. The Hardware Notes will list supported audio devices and which FreeBSD driver it uses. Start by identifying which driver will be needed for your specific audio device.

The device driver will need to be loaded to use the sound card, this can be easily done with [kldload(8)](https://www.freebsd.org/cgi/man.cgi?query=kldload&sektion=8&format=html). To load the intel-specific driver, for example:

```
# kldload snd_hda
```

The driver can be automatically loaded on boot by configuring `/boot/loader.conf`. Available sound modules are listed in the `snd(1)` manual page, these can be viewed by using:

```
 # man -k snd
```

Once the sound module has been checked, add a line to `/boot/loader.conf` to automatically load the driver. The line for the previous Intel driver would be:

```
snd_hda_load="YES"
```

To simplify identifying and loading a driver, the `snd_driver` module, a meta driver that loads all of the common sound drivers, can also be loaded:

```
snd_driver_load="YES"
```



## 2. Setting up Bluetooth

If the audio output require a Bluetooth connection, further configurations will have to be made to ensure Bluetooth support is loaded and configured. This section can be skipped if Bluetooth is not needed.

------

### 2.1 Loading Bluetooth Support

Before attaching a Bluetooth device, determine which Bluetooth driver it uses. A broad variety of Bluetooth USB dongles are supported by [ng_ubt(4)](https://www.freebsd.org/cgi/man.cgi?query=ng_ubt&sektion=4&format=html). Broadcom BCM2033 based Bluetooth devices are supported by the [ubtbcmfw(4)](https://www.freebsd.org/cgi/man.cgi?query=ubtbcmfw&sektion=4&format=html) and [ng_ubt(4)](https://www.freebsd.org/cgi/man.cgi?query=ng_ubt&sektion=4&format=html) drivers. Serial and UART based Bluetooth devices are supported by [ng_h4(4)](https://www.freebsd.org/cgi/man.cgi?query=ng_h4&sektion=4&format=html) and [hcseriald(8)](https://www.freebsd.org/cgi/man.cgi?query=hcseriald&sektion=8&format=html). For example, if the device uses the [ng_ubt(4)](https://www.freebsd.org/cgi/man.cgi?query=ng_ubt&sektion=4&format=html) driver:

```
# kldload ng_ubt
```

If the Bluetooth device will be attached to the system during system startup, the system can be configured to load the module at boot by adding the driver to `/boot/loader.conf`:

```
ng_ubt_load="YES"
```

Once the driver is loaded, connect the Bluetooth device. If the driver load was successful, output similar to the following should appear on the console and in `/var/log/messages`:

```
ubt0: vendor 0x0a12 product 0x0001, rev 1.10/5.25, addr 2
ubt0: Interface 0 endpoints: interrupt=0x81, bulk-in=0x82, bulk-out=0x2
ubt0: Interface 1 (alt.config 5) endpoints: isoc-in=0x83, isoc-out=0x3,
      wMaxPacketSize=49, nframes=6, buffer size=294
```

To start and stop Bluetooth, use the driver’s startup script:

```
# service bluetooth start ubt0
```

### 2.2 Finding Other Bluetooth Devices

FreeBSD uses [hccontrol(8)](https://www.freebsd.org/cgi/man.cgi?query=hccontrol&sektion=8&format=html) to find and identify Bluetooth devices within RF proximity.

One of the most common tasks is discovery of Bluetooth devices within RF proximity. This operation is called *inquiry*. Inquiry and other HCI related operations are done using [hccontrol(8)](https://www.freebsd.org/cgi/man.cgi?query=hccontrol&sektion=8&format=html). To display a list of devices that are in range use:

```
% hccontrol -n ubt0hci inquiry
Inquiry result, num_responses=1
Inquiry result #0
       BD_ADDR: 00:80:37:29:19:a4
       Page Scan Rep. Mode: 0x1
       Page Scan Period Mode: 00
       Page Scan Mode: 00
       Class: 52:02:04
       Clock offset: 0x78ef
Inquiry complete. Status: No error [00]
```

**Note**: only devices that are set to discoverable mode will be listed*.*

The **`BD_ADDR`** is the unique address of a Bluetooth device, similar to the MAC address of a network card. This address is needed for further communication with a device. To to obtain the human readable name that was assigned to the remote device:

```
% hccontrol -n ubt0hci remote_name_request 00:80:37:29:19:a4
BD_ADDR: 00:80:37:29:19:a4
Name: Example Bluetooth
```

The Bluetooth system provides a point-to-point connection between two Bluetooth units, or a point-to-multipoint connection which is shared among several Bluetooth devices. The following example shows how to create a connection to a remote device:

```
% hccontrol -n ubt0hci create_connection BT_ADDR
```

`create_connection` accepts `BT_ADDR` as well as host aliases in `/etc/bluetooth/hosts`.

The following example shows how to obtain the list of active baseband connections for the local device:

```
% hccontrol -n ubt0hci read_connection_list
Remote BD_ADDR    Handle Type Mode Role Encrypt Pending Queue State
00:80:37:29:19:a4     41  ACL    0 MAST    NONE       0     0 OPEN
```



## 3. Graphics Card Sound Driver

------

Modern graphics cards often come with their own sound driver, which may not be used as the default device. To confirm, run dmesg and look for the `pcm` entries:

```
...
pcm0: <HDA NVidia (Unknown) PCM #0 DisplayPort> at cad 0 nid 1 on hdac0
pcm1: <HDA NVidia (Unknown) PCM #0 DisplayPort> at cad 1 nid 1 on hdac0
pcm2: <HDA NVidia (Unknown) PCM #0 DisplayPort> at cad 2 nid 1 on hdac0
pcm3: <HDA NVidia (Unknown) PCM #0 DisplayPort> at cad 3 nid 1 on hdac0
hdac1: HDA Codec #2: Realtek ALC889
pcm4: <HDA Realtek ALC889 PCM #0 Analog> at cad 2 nid 1 on hdac1
pcm5: <HDA Realtek ALC889 PCM #1 Analog> at cad 2 nid 1 on hdac1
pcm6: <HDA Realtek ALC889 PCM #2 Digital> at cad 2 nid 1 on hdac1
pcm7: <HDA Realtek ALC889 PCM #3 Digital> at cad 2 nid 1 on hdac1
...
```

In this example, the graphics card (`NVidia`) has been enumerated before the sound card (`Realtek`). This can be changed to use the sound card as the default device with:

```
# sysctl hw.snd.default_unit=n
```

where `n` is the number of the sound device to prioritize. In this example, it should be `4`. Make this change permanent by adding the following line to `/etc/sysctl.conf`:

```
hw.snd.default_unit=4
```



## 4. Automatically Switching to Headphones

------

Some systems may struggle with switching between audio outputs, fortunately FreeBSD allows for these to be specified in `device.hints`, which can be configured for automatic switchover. To start, identify how your system is enumerating the outputs with:

```
# dmesg | grep pcm
pcm0: <Realtek ALC892 Analog> at nid 23 and 26 on hdaa0
pcm1: <Realtek ALC892 Right Analog Headphones> at nid 22 on hdaa0
...
```

Add the following line to `/boot/device.hints` **using the highlighted values from your own system**. These will likely be different than the example. In this example, colored text has been used to identify where in the original string the values originated.

```
hint.hdac.0.cad0.nid22.config="as=1 seq=15 device=Headphones" 
hint.hdac.0.cad0.nid26.config="as=2 seq=0 device=speakers"
```



## 5. Testing Sound

------

To confirm that the sound card has been detected and properly configured, run `dmesg | grep pcm`. This example is from a system with a built-in Conexant chipset:

```
pcm0: <NVIDIA (0x001c) (HDMI/DP 8ch)> at nid 5 on hdaa0
pcm1: <NVIDIA (0x001c) (HDMI/DP 8ch)> at nid 6 on hdaa0
pcm2: <Conexant CX20590 (Analog 2.0+HP/2.0)> at nid 31,25 and 35,27 on hdaa1
```

The status of the sound card may also be checked using this command:

```
# cat /dev/sndstat
FreeBSD Audio Driver (newpcm: 64bit 2009061500/amd64)
Installed devices:
pcm0: <NVIDIA (0x001c) (HDMI/DP 8ch)> (play)
pcm1: <NVIDIA (0x001c) (HDMI/DP 8ch)> (play)
pcm2: <Conexant CX20590 (Analog 2.0+HP/2.0)> (play/rec) default
```

The output depends on which sound card has been detected, so the result may look different. However, if no pcm devices are listed, check if the correct driver was loaded in the first step.

Another quick way to test the card is to send data to `/dev/dsp`:

```
% cat filename > /dev/dsp
```

Any file can be used for this and will produce noise through the connected audio device.



## The End