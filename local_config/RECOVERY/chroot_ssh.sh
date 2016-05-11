#!/bin/bash

#sudo mount /dev/sda2 /mnt
for i in /dev /dev/pts /proc /sys; do sudo mount -B $i /mnt/tmp$i;  done
#sudo cp /etc/resolv.conf /mnt/etc/resolv.conf
sudo chroot /mnt

echo "sudo /usr/sbin/sshd"
echo "sudo ifconfig wlan0 up"
