#!/bin/sh

set -x

setup-keymap us us

setup-interfaces -i <<EOF
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF

echo "root:vmpass" | chpasswd

setup-apkrepos http://dl-cdn.alpinelinux.org/alpine/v3.8/main

apk add --quiet openssh
rc-update --quiet add sshd default
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "ttyS0" >> /etc/securetty
echo "ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100" >> /etc/inittab

rc-update --quiet add networking boot
rc-update --quiet add urandom boot

ERASE_DISKS=/dev/vda setup-disk -s 0 -m sys /dev/vda

reboot
