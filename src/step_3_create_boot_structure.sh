#!/bin/bash

. CONFIG.sh

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set


function main() {
    # Cleanup just incase we've ran this before.
    sudo rm -rf image/casper/*
    sudo rm -rf image/isolinux/*

    echo "Moving ISO linux parts..."
    move_iso_linux_parts;

    echo "\nWhich boot style do you want to use?"
    echo "\t1) Text Boot"
    echo "\t2) GUI Boot"
    read -p "--> : " ANSR
    while [[ $ANSR != "1" ]] && [[ $ANSR != "2" ]]; do
        read -p "--> : " ANSR
    done
    case $ANSR in
        "1" )  isolinux_text_boot;;
        "2" ) isolinux_gui_boot;;
    esac

    echo "Creating manifest..."
    create_manifest;
    echo "Squashing chroot filesystem..."
    compress_chroot;
    echo "Creating diskdefines data..."
    diskdefines;
    echo "Creating recognition info..."
    remix_recognition;
    echo "Creating MD5 data..."
    md5_cal;
}

function move_iso_linux_parts() {
    clear
    # We will need a kernel and an initrd that was built with the Casper scripts.
    # Grab them from the chroot. Use the current version.
    # Note that before 9.10, the initrd was in gz not lz format...
    # Should look inti makeinitcpio:
    #    https://wiki.archlinux.org/title/Mkinitcpio
    # Is that the same stuff? I'm thinking not but...I r dumb.
    echo "If this fails then use what's in chroot/boot/...:"
    echo "Copying ${CHROOT_PTH}/boot/vmlinuz-5.4.**-**-generic to image/casper/vmlinuz"
    sudo cp "${CHROOT_PTH}"/boot/vmlinuz-5.4.**-**-generic image/casper/vmlinuz
    echo "Copying ${CHROOT_PTH}/boot/initrd.img-5.4.**-**-generic to image/casper/initrd.lz"
    sudo cp "${CHROOT_PTH}"/boot/initrd.img-5.4.**-**-generic image/casper/initrd.lz
}

function isolinux_text_boot() {
    # We need the isolinux and memtest binaries.
    # (Note: some distros place file isolinux.bin under /usr/lib/syslinux .)
    sudo cp /usr/lib/ISOLINUX/isolinux.bin image/isolinux/
    sudo cp /usr/lib/syslinux/modules/bios/ldlinux.c32 image/isolinux/ # for syslinux 5.00 and newer
    # sudo cp /boot/memtest86+.bin image/install/memtest
    cp BOOT_STRUCTURE_PARTS/isolinux/isolinux.cfg image/isolinux/

    # To give some boot-time instructions to the user
    echo "\nMoving splash parts to image/isolinux"
    cp BOOT_STRUCTURE_PARTS/splash_screen/isolinux.txt image/isolinux/
    cp BOOT_STRUCTURE_PARTS/splash_screen/splash.rle image/isolinux/
}


function isolinux_gui_boot() {
    # Use local options
    sudo cp BOOT_STRUCTURE_PARTS/isolinux/* image/isolinux/
    sudo rm image/isolinux/isolinux.cfg_text_version
    sudo mv image/isolinux/isolinux.cfg_gui_version image/isolinux/isolinux.cfg
}



function create_manifest() {
    sudo chroot ${CHROOT_PTH} dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee image/casper/filesystem.manifest
    sudo cp -v image/casper/filesystem.manifest image/casper/filesystem.manifest-desktop
    REMOVE='ubiquity ubiquity-frontend-gtk ubiquity-frontend-kde casper lupin-casper live-initramfs user-setup discover1 xresprobe os-prober libdebian-installer4'
    for i in $REMOVE; do
        sudo sed -i "/${i}/d" image/casper/filesystem.manifest-desktop
    done
}

function compress_chroot() {
    sudo mksquashfs "${CHROOT_PTH}" image/casper/filesystem.squashfs \
        -b 1048576 -comp xz -Xdict-size 100%

    printf $(sudo du -sx --block-size=1 "${CHROOT_PTH}" | cut -f1) > image/casper/filesystem.size
}


function diskdefines() {
cat <<EOF > image/README.diskdefines
#define DISKNAME  ${OS_NAME}
#define TYPE  binary
#define TYPEbinary  1
#define ARCH  ${ARCH}
#define ARCH${ARCH}  1
#define DISKNUM  1
#define DISKNUM1  1
#define TOTALNUM  0
#define TOTALNUM0  1
EOF
}

function remix_recognition() {
    touch image/.disk/base_installable
    echo "full_cd/single" > image/.disk/cd_type
    echo "${OS_NAME} ${OS_VER}" > image/.disk/info
    echo "http//your-release-notes-url.com" > image/.disk/release_notes_url
}

function md5_cal() {
    cd image/
    find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" > md5sum.txt
}

main $@;
