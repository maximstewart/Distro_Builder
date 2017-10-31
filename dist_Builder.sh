#!/bin/bash
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
        sleep 4
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
    if [ ! -f *.iso ] && [ ! -d squashfs-root ]; then
        clear
        echo "Sorry, there is no iso or squashfs-root dir to work with in the current directory."
        echo "Going back to download ans Ubuntu Mini Iso..."
        sleep 4
        getIso
    elif [ -f *.iso ] && [ -d squashfs-root ]; then
        clear
        echo "Both an iso and squashfs-root are present..."
        echo "Which do you wish to use?"
        read -p "1.) `echo *.iso`
2.) Use former session: squashfs-root
3.) Exit
--> : " ANSR
        while [[ $ANSR != "1" ]] && [[ $ANSR != "2" ]] && \
              [[ $ANSR != "3" ]]
        do
            read -p "1.) `echo *.iso`
2.) Use former session: squashfs-root
3.) Exit
--> : " ANSR
        done

        if [[ $ANSR == "1" ]]; then
              bash cleanup.sh
              mountAndCopy
        elif [[ $ANSR == "2" ]]; then
             chrootr
        elif [[ $ANSR == "3" ]]; then
             exit
        fi
    elif [ -d squashfs-root ]; then
            clear
            echo "Squashfs-root directory found. Chrooting to directory."
            sleep 4
            chrootr
    elif [ -f *.iso ]; then
            clear
            echo "Iso found; mounting and copying to proper file structure. Then chrooting in..."
            sleep 4
            mountAndCopy
            chrootr
    fi
}

mountAndCopy() {
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
    ## Copy over build files 'n scripts
        cp AUTO_INSTALL.sh squashfs-root/
        cp -r COPY_OVER_TO_CHROOT/ squashfs-root/
}

chrootr() {
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
