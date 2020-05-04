apt-get update && apt-get upgrade
apt-get autoremove --purge -y
apt-get autoclean -y
apt-get clean

rm /var/lib/dbus/machine-id
rm -rf /tmp/*
rm /etc/resolv.conf
rm /sbin/initctl
rm -rf /usr/src/*   # Should be OK to clean this.

dpkg-divert --rename --remove /sbin/initctl

# Remove old kernels
# dpkg -l 'linux-*' | sed '/^ii/!d;/hwe/d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt -y purge; update-grub
