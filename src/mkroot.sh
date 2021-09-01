#!/bin/bash

. CONFIG.sh

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set




function create_file_init_and_configs() {

# Toy init system to look over eventually.
#
# cat > "$ROOT"/init << 'EOF' &&
# #!/bin/sh
# export HOME=/home
# export PATH=/bin:/sbin
# mountpoint -q proc || mount -t proc proc proc
# mountpoint -q sys || mount -t sysfs sys sys
# if ! mountpoint -q dev
# then
#   mount -t devtmpfs dev dev || mdev -s
#   mkdir -p dev/pts
#   mountpoint -q dev/pts || mount -t devpts dev/pts dev/pts
# fi
# if [ $$ -eq 1 ]
# then
#   # Don't allow deferred initialization to crap messages over the shell prompt
#   echo 3 3 > /proc/sys/kernel/printk
#   # Setup networking for QEMU (needs /proc)
#   ifconfig eth0 10.0.2.15
#   route add default gw 10.0.2.2
#   [ "$(date +%s)" -lt 1000 ] && rdate 10.0.2.2 # or time-b.nist.gov
#   [ "$(date +%s)" -lt 10000000 ] && ntpd -nq -p north-america.pool.ntp.org
#   [ -z "$CONSOLE" ] &&
#     CONSOLE="$(sed -rn 's@(.* |^)console=(/dev/)*([[:alnum:]]*).*@\3@p' /proc/cmdline)"
#   [ -z "$HANDOFF" ] && HANDOFF=/bin/sh && echo Type exit when done.
#   [ -z "$CONSOLE" ] && CONSOLE=console
#   exec /sbin/oneit -c /dev/"$CONSOLE" $HANDOFF
# else
#   /bin/sh
#   umount /dev/pts /dev /sys /proc
# fi
# EOF
# chmod +x "$ROOT"/init &&

cat > "$ROOT"/etc/passwd << 'EOF' &&
root::0:0:root:/root:/bin/sh
guest:x:500:500:guest:/home/guest:/bin/sh
nobody:x:65534:65534:nobody:/proc/self:/dev/null
EOF

cat > "$ROOT"/etc/group << 'EOF' &&
root:x:0:
guest:x:500:
EOF

    echo "nameserver 8.8.8.8" > "$ROOT"/etc/resolv.conf || exit 1
}


function create_file_structure() {
    rm -rf "$ROOT" &&
    mkdir -p "$ROOT"/{etc,tmp,proc,sys,dev,home,mnt,root,usr/{bin,sbin,lib},var} &&
    chmod a+rwxt "$ROOT"/tmp &&
    ln -s usr/bin "$ROOT/bin" &&
    ln -s usr/sbin "$ROOT/sbin" &&
    ln -s usr/lib "$ROOT/lib"
}

function main() {
    SCRIPTPATH="$( cd "$(dirname "")" >/dev/null 2>&1 ; pwd -P )"
    cd "${SCRIPTPATH}"
    echo "Working Dir: " $(pwd)

    create_file_structure
    create_file_init_and_configs
}
main $@;
