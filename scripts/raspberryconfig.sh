#!/bin/bash

# This script will be run in chroot under qemu.

echo "Creating Fstab File"

touch /etc/fstab
echo "proc            /proc           proc    defaults        0       0
/dev/mmcblk0p1  /boot           vfat    defaults        0       0
/dev/mmcblk0p2  /               ext4    defaults,noatime  0   1
" > /etc/fstab

echo "Writing cmdline file"
echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait" > /boot/cmdline.txt

echo "Adding BCM Module"

echo "
snd_bcm2835
" >> /etc/modules

echo "Installing Kernel from Rpi-Update"

apt-get update
apt-get -y install git-core binutils ca-certificates curl
sudo curl -L --output /usr/bin/rpi-update https://raw.githubusercontent.com/Hexxeh/rpi-update/master/rpi-update && sudo chmod +x /usr/bin/rpi-update
touch /boot/start.elf
mkdir /lib/modules
mkdir /lib/firmware
SKIP_BACKUP=1 rpi-update e38850519c56b835dbd1c81e04d9307e154c36ed

echo "Cleaning APT Cache"
apt-get clean
