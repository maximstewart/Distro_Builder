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


# ----  Get rid of some 'unneeded' blob. (Probably doing satans work with how this is aproached....)
# /usr/lib/firmware consumes nearly 550MB!! Ouch....

mkdir /usr/lib/me-tmp/
mv /usr/lib/firmware/RTL8192E /usr/lib/me-tmp/
mv /usr/lib/firmware/amd /usr/lib/me-tmp/
mv /usr/lib/firmware/amd-ucode /usr/lib/me-tmp/
mv /usr/lib/firmware/amdgpu /usr/lib/me-tmp/
mv /usr/lib/firmware/intel /usr/lib/me-tmp/
mv /usr/lib/firmware/intel-ucode /usr/lib/me-tmp/
mv /usr/lib/firmware/nvidia /usr/lib/me-tmp/
mv /usr/lib/firmware/qcom /usr/lib/me-tmp/

rm -rf /usr/lib/firmware/*
mv /usr/lib/me-tmp/* /usr/lib/firmware/
rmdir /usr/lib/me-tmp
