#!/bin/bash
#---------------- Copyright notices and creator info-----------------------------#
#
# By Maxim F. Stewart Contact: [maximstewart1@gmail.com]
#
# Copyright 2013 Maxim F. Stewart
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. If not, see <http://www.gnu.org/licenses/>.
#
#
#
#
#--------------------------------------------------------------------------------#
. CONFIG

rootNisoChk() {
    if [ $(id -u) -eq 0 ]; then
         softChk
    else
        echo "Sorry, you are not root."
        exit 1
    fi
}

softChk() {
xyphr=$(which Xephyr)        ## Chroot view window || alt desktop window
sysLnx=$(which syslinux)     ## Casper stuff
squash=$(which unsquashfs)   ## Squashfs-tools
genIso=$(which genisoimage)  ## Iso maker

    clear
    if [[ $xyphr == "" ]] || [[ $sysLnx == "" ]] || \
       [[ $squash == "" ]] || [[ $genIso == "" ]]; then
        echo "##  Missing some packages  ##"
        echo "Xephyr :" $xyphr
        echo "Syslinux :" $sysLnx
        echo "Squashfs-tools :" $squash
        echo "Genisoimage :" $genIso
        echo ""
        echo "Going to run :"
        echo "     apt-get install xserver-xephyr syslinux squashfs-tools genisoimage -y"
        sleep 3
        apt-get install xserver-xephyr syslinux squashfs-tools genisoimage -y
        getIso
    else
        getIso
    fi
}

getIso() {
    clear
    echo "##  Download Ubuntu Mini Remix  ##"
    echo "Would you like to download an Ubuntu Mini Iso?"
    read -p "(yY/Nn) --> " ANSR
    while [[ $ANSR != "y" ]] && [[ $ANSR != "Y" ]] && \
          [[ $ANSR != "n" ]] && [[ $ANSR != "N" ]]
    do
        read -p "(yY/Nn) --> " ANSR
    done

    ## Check if dl iso is wanted then dl it
    if [[ $ANSR == "Y" ]] || [[ $ANSR == "y" ]]; then
        clear
        echo "##  Default Settings Or Set Version And Arch  ##"
        echo " Would you like to use the default choices? "
        read -p "(yY/Nn) --> " ANSR
        while [[ $ANSR != "y" ]] && [[ $ANSR != "Y" ]] && \
              [[ $ANSR != "n" ]] && [[ $ANSR != "N" ]]
        do
            read -p "(yY/Nn) --> " ANSR
        done

        if [ $ANSR == "N" ] || [ $ANSR == "n" ]; then
            clear
            echo "##  Get Version  ##"
            echo "What version would you like?"
            echo "Examples :"
            echo "    LTS : 16.04"
            echo "    Non-LTS : 15.10"
            echo "Be very sure you are correctly entering the version."
                read -p "Version --> : " VERSION
            clear
            echo "##  Get Architect  ##"
            echo "What version would you like?"
            echo "    32bit : i386"
            echo "    64bit : amd64"
            echo "Be very sure you are correctly entering the architect."
                read -p "Arch --> : " ARCH
            wget http://ubuntu-mini-remix.mirror.garr.it/mirrors/ubuntu-mini-remix/${VERSION}/ubuntu-mini-remix-${VERSION}-${ARCH}.iso
        else
            wget http://ubuntu-mini-remix.mirror.garr.it/mirrors/ubuntu-mini-remix/${VERSION}/ubuntu-mini-remix-${VERSION}-${ARCH}.iso
            main
        fi
    else
        main
    fi
}

main() {
    if ! [ -f *.iso ]; then
        echo "Sorry, there is no iso to work with in the current directory."
        exit 1
    fi

    ## Prep dirs
        mkdir iso/ mnt/

    ## Prep filesystem
        mount -o loop *.iso mnt/
        cp -r mnt/. iso/ && \
            mv iso/casper/filesystem.squashfs .

    ## Unspuashfs the squashfs
        unsquashfs filesystem.squashfs && \
            rm filesystem.squashfs

    ## Cleanup some prep items
        umount mnt/ && rmdir mnt/
        rm *.iso

    chrootr
}

chrootr() {
    ## Copy over build files 'n scripts
        cp AUTO_INSTALL.sh squashfs-root/
        cp -r COPY_OVER_TO_CHROOT/ squashfs-root/

    ## Set Xephyr and set chrooting mounts
        Xephyr -resizeable -screen "${RES}" "${ID}" &
        cd squashfs-root/
        mount -t proc proc proc/
        mount -t sysfs sys sys/
        mount -o bind /dev dev/
        cp /etc/resolv.conf etc/

    ##  Enter env with chroot
        chroot . bash

    ## Unmount binds
        umount -lf dev/
        umount -lf proc/
        umount -lf sys/
        cd ..

    setConfigs
}

setConfigs() {
    ## Edit Iso boot info bits
        sed -i 3s/Ubuntu/"${NAME}"/g iso/isolinux/txt.cfg
        sed -i 7s/Ubuntu/"${NAME}"/g iso/isolinux/txt.cfg

    ## Set Live user and Hostename
        sed -i 14s/Ubuntu/"${lvUSER}"/g squashfs-root/etc/casper.conf
        sed -i 5,7s/ubuntu/"${lvUSER}"/g squashfs-root/etc/casper.conf


    ## Recreate manifest and clean it  Note: MUST be after all setting changes
        chroot squashfs-root/ dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee iso/casper/filesystem.manifest
        cp -v iso/casper/filesystem.manifest iso/casper/filesystem.manifest-desktop
        for i in $REMOVE
        do
              sed -i "/${i}/d" iso/casper/filesystem.manifest-desktop
        done

    genSqush
}

genSqush() {
    ## Recreate squashfs
        mksquashfs squashfs-root/ iso/casper/filesystem.squashfs -comp xz -e squashfs-root/boot

    ## Write the filesystem.size file, which is needed by the installer:
        chmod 644 iso/casper/filesystem.size
        printf $(sudo du -sx --block-size=1 squashfs-root/ | cut -f1) > iso/casper/filesystem.size
        chmod 444 iso/casper/filesystem.size

    ## Calculate MD5
        (cd iso && find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" > SHA256SUMS)
    genIsoImg
}

genIsoImg() {
    ## Generate Iso
        cd iso/
        sudo mkisofs -D -r -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../${NAME}.iso .
}
rootNisoChk
