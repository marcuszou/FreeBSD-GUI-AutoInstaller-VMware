# FreeBSD 14 - Resize UFS/ZFS Partition in Physical Computer or VM

by Marcus Zou



## Questions

As I tested out FreeBSD 14's official VMDK, I found the `UFS` edition has issue - cannot be resized (looks okay, but actually not resizeable when installing any apps, the error be like " disk full in /var/cache/pkg... "), then use the `ZFS` edition or the regular VMDK.xz), I tried to install the typical GUI, during which the system complains "`Disk full`" since the official disk size of VM was set at 6GB only (bad setting by FreeBSD). Now I have to expand the disk/partition.



## Answers

1. I have expand the disk size from 6GB to 50GB. By the way - expanding disk size in VMware Workstation does not expand the data/root partition inside FreeBSD at all. then I have to manually populate the __full disk__ with the newly added 44GB (50-6=44).

2. Boot up the VM and select "**S**" to boot into **Single user** mode.

3. Now of course the partitioning situation of such disk is that the FreeBSD owns quite a large free space by typing the `gpart show` command at # prompt.

   ```
   =>       34  104857533  da0  GPT  (50G)
            34        122    1  freebsd-boot  (61K)
           156      66584    2  efi  (33M)
         66740    2097152    3  freebsd-swap  (1.0G)
       2163892   10485760    4  freebsd-ufs  (5.0G)
      12649652   92207915       - free -  (44G)
   ```

4. Since the index of the __full disk__ is __4__, execute the following code:

   ```
   gpart resize -i 4 da0
   ```

5. Check up again by issuing `gpart show`:

   ```
   =>       34  104857533  da0  GPT  (50G)
            34        122    1  freebsd-boot  (512K)
           156      66584    2  efi  (33M)
         66740    2097152    3  freebsd-swap  (1.0G)
       2163892  102693675    4  freebsd-ufs  (49G)
   ```

6. Then type `poweroff` to power off the VM.

7. In case '`gpart show`' shows da0 corrupted, execute:

   ```
   gpart recover da0
   ```

8. Done! Incredibly easy, isn't it?



