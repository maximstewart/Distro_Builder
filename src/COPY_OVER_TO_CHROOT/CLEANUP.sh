# If we installed software, be sure to run
rm /var/lib/dbus/machine-id


# Before exiting the chroot, remove the diversion:
# Earlier this guide asked you to make a backup copy of /sbin/initctl.
# If the following command does not restore this file, then restore from the backup copy you made.
apt-get update && apt-get upgrade
apt-get autoremove --purge -y
apt-get autoclean -y
apt-get clean

rm -rf /tmp/*
rm /etc/resolv.conf

# Remove old kernels
dpkg -l 'linux-*' | sed '/^ii/!d;/hwe/d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt -y purge; update-grub

rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl
