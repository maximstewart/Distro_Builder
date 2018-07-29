#!/bin/bash
. CONFIG

rootNisoChk() {
    if [ "$(id -u)" -eq 0 ]; then
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
        echo -e "##  Missing some packages  ##\n" \
                "Xephyr :" "${xyphr}\n" \
                "Syslinux :" "${sysLnx}\n" \
                "Squashfs-tools :" "${squash}\n" \
                "Genisoimage :" "${genIso}\n" \
                "Going to run :\n" \
                "     apt-get install xserver-xephyr syslinux squashfs-tools genisoimage -y"
        sleep 4
        apt-get install xserver-xephyr syslinux squashfs-tools genisoimage -y
        getIso
    else
        getIso
    fi
}

getIso() {
    clear
    echo -e "##  Download Ubuntu Mini Remix  ##\n" \
            "Would you like to download an Ubuntu Mini Iso?"
    read -p "(yY/Nn) --> " ANSR
    while [[ $ANSR != "y" ]] && [[ $ANSR != "Y" ]] && \
          [[ $ANSR != "n" ]] && [[ $ANSR != "N" ]]
    do
        read -p "(yY/Nn) --> " ANSR
    done

    ## Check if dl iso is wanted then dl it
    if [[ $ANSR == "Y" ]] || [[ $ANSR == "y" ]]; then
        clear
        echo -e "##  Default Settings Or Set Version And Arch #\n" \
                "Would you like to use the default choices? "
        read -p "(yY/Nn) --> " ANSR
        while [[ $ANSR != "y" ]] && [[ $ANSR != "Y" ]] && \
              [[ $ANSR != "n" ]] && [[ $ANSR != "N" ]]
        do
            read -p "(yY/Nn) --> " ANSR
        done

        if [ "${ANSR}" == "N" ] || [ "${ANSR}" == "n" ]; then
            clear
            echo -e "##  Get Version  ##\n" \
                    "What version would you like?\n" \
                    "Examples :\n" \
                    "    LTS : 16.04\n" \
                    "    Non-LTS : 15.10\n" \
                    "Be very sure you are correctly entering the version."
            read -p "Version --> : " VERSION
            clear
            echo -e "##  Get Architect  ##\n" \
                    "What version would you like?\n" \
                    "    32bit : i386\n" \
                    "    64bit : amd64\n" \
                    "Be very sure you are correctly entering the architect."
            read -p "Arch --> : " ARCH
            wget http://ubuntu-mini-remix.mirror.garr.it/mirrors/ubuntu-mini-remix/"${VERSION}"/ubuntu-mini-remix-"${VERSION}"-"${ARCH}".iso
        else
            wget http://ubuntu-mini-remix.mirror.garr.it/mirrors/ubuntu-mini-remix/"${VERSION}"/ubuntu-mini-remix-"${VERSION}"-"${ARCH}".iso
            main
        fi
    else
        mkdir squashfs-root/
        sudo debootstrap --components=main,contrib,nonfree \
                         --variant=minbase \
                         --include=linux-generic,grub-pc,nano,ssh \
                         --arch=amd64 bionic \
                         ./squashfs-root/
        main
    fi
}

main() {
    list=$(find . -maxdepth 1 -name "*.iso" -printf '%P\n')
    if [[ "${list}" == "" ]] && [ ! -d squashfs-root ]; then
        clear
        echo -e "Sorry, there is no iso or squashfs-root dir to work with in the current directory.\n"
             "Going back to download an Ubuntu Mini Iso..."
        sleep 4
        getIso
    elif [[ "${list}" != "" ]] && [ -d squashfs-root ]; then
        ANSR=""
        while [[ $ANSR != "1" ]] && [[ $ANSR != "2" ]] && [[ $ANSR != "3" ]]; do
            clear
            echo -e "Both an iso(s) and squashfs-root are present...\n" \
                    "Which do you wish to use?\n" \
                    "1.) Use ISO(s)\n" \
                    "2.) Use former session: squashfs-root\n" \
                    "3.) Exit"
            read -p "--> : " ANSR
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
    elif [[ "${list}" != "" ]]; then
        clear
        echo -e "Iso(s) found. Will mount one and copying to proper file structure.\n" \
                "Then will chroot in..."
        sleep 4
        mountAndCopy
        chrootr
    fi
}

mountAndCopy() {
    ## Prep dirs
        mkdir iso/ mnt/

    ## Prep filesystem
        isoList=($(find . -maxdepth 1 -name "*.iso" -printf '%P\n'))
        count="${#isoList[@]}"
        ANSR=""

        while [[ "${ANSR}" > "${count}" || "${ANSR}" < "0" ]]; do
            x=0;
            clear
            for i in "${isoList[@]}"; do
                echo "$x - ${i}"
                ((x++))
            done
            echo "Chose the ISO from above using the number."
            read -p "-->: " ANSR
        done

        echo "You chose :  ${isoList[$ANSR]}"
        mount -o loop ./"${isoList[$ANSR]}" mnt/
        cp -r mnt/. iso/ && \
        mv iso/casper/filesystem.squashfs .

    ## Unspuashfs the squashfs
        unsquashfs filesystem.squashfs && rm filesystem.squashfs

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
        chroot squashfs-root/ dpkg-query -W --showformat="${Package} ${VERSION}\n" | sudo tee iso/casper/filesystem.manifest
        cp -v iso/casper/filesystem.manifest iso/casper/filesystem.manifest-desktop
        for i in $REMOVE; do
              sed -i "/${i}/d" iso/casper/filesystem.manifest-desktop
        done
    genSqush
}

genSqush() {
    ## Recreate squashfs
        mksquashfs squashfs-root/ iso/casper/filesystem.squashfs -b 1048576 -comp xz -Xdict-size 100% -e squashfs-root/boot

    ## Write the filesystem.size file, which is needed by the installer:
        chmod 644 iso/casper/filesystem.size
        sudo du -sx --block-size=1 squashfs-root/ | cut -f1 > iso/casper/filesystem.size
        chmod 444 iso/casper/filesystem.size

    ## Calculate MD5
        (cd iso && find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" > SHA256SUMS)
    genIsoImg
}

genIsoImg() {
    ## Generate Iso
        cd iso/
        sudo mkisofs -D -r -cache-inodes -J -l -b isolinux/isolinux.bin -c \
        isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o \
                                                             ../"${NAME}".iso .
}
rootNisoChk
