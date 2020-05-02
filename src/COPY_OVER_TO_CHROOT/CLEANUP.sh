# If we installed software, be sure to run
rm /var/lib/dbus/machine-id


# Before exiting the chroot, remove the diversion:
# Earlier this guide asked you to make a backup copy of /sbin/initctl.
# If the following command does not restore this file, then restore from the backup copy you made.
rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl


# Remove old kernels
ls /boot/vmlinuz-5.4.**-**-generic > list.txt
sum=$(cat list.txt | grep '[^ ]' | wc -l)

if [ $sum -gt 1 ]; then
    dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge
fi
rm list.txt


apt-get clean
rm -rf /tmp/*
rm /etc/resolv.conf
