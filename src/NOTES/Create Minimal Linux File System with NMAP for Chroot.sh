#!/bin/bash
#more info here http://www.cyberciti.biz/faq/debian-ubuntu-restricting-ssh-user-session-to-a-directory-chrooted-jail/

fs="$PWD/jail"
echo "Creating ${fs}..."
mkdir -p ${fs}/{etc,usr/{bin,lib},bin,lib}/

mkdir -p $fs/dev/
mknod -m 666 $fs/dev/null c 1 3
mknod -m 666 $fs/dev/tty c 5 0
mknod -m 666 $fs/dev/zero c 1 5
mknod -m 666 $fs/dev/random c 1 8

cp -v /lib/ld-linux.so.2 $fs/lib/

chown root:root $fs
chmod 0755 $fs

wget "http://www.busybox.net/downloads/binaries/latest/busybox-i686" -O ${fs}/bin/busybox
chmod +x ${fs}/bin/busybox

cd ${fs}/bin
./busybox  --help | \
sed -e '1,/^Currently defined functions:/d' \
    -e 's/[ \t]//g' -e 's/,$//' -e 's/,/\n/g' | \
while read app ; do
  if [ "$app" != "" ]; then
    printf "linking %-12s ...\n" "$app"
    ln -sf "./busybox" "$app"
    ls -ld "$app"
  fi
done

echo "nameserver 8.8.8.8" > $fs/etc/resolv.conf
echo "search 8.8.8.8" >> $fs/etc/resolv.conf

#add nmap
cp -v /usr/bin/nmap $fs/usr/bin/nmap_real
#create unprivileged nmap script
cat << EOF > $fs/usr/bin/nmap
#!/bin/sh
nmap_real --unprivileged \$*
EOF
chmod +x $fs/usr/bin/nmap

mkdir -p $fs/{usr/share/nmap/,etc/services}
#cp -vr /usr/share/nmap $fs/usr/share/nmap/
ldd /usr/bin/nmap|while read line;
do  
  echo "$line"|\
  awk '{print $3}'
done|grep lib|while read line;
do 
  cp -v "$line" $fs/usr/lib/;
done

clear
echo "welcome to your chroot!"
chroot $fs sh