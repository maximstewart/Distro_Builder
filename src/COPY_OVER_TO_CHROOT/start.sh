#!/bin/bash

. CONFIG.sh

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set


function main() {
    clear;
    start_menu_mesage;
    read -p "--> : " ANSR
    while [[ $ANSR != "0" ]] && [[ $ANSR != "1" ]] && \
          [[ $ANSR != "2" ]] && [[ $ANSR != "3" ]] && \
          [[ $ANSR != "4" ]] && [[ $ANSR != "5" ]] && \
          [[ $ANSR != "6" ]] && [[ $ANSR != "7" ]] && \
          [[ $ANSR != "8" ]] && [[ $ANSR != "9" ]] && \
          [[ $ANSR != "10" ]] && [[ $ANSR != "11" ]]; do
        read -p "--> : " ANSR
    done
    case $ANSR in
        "1" ) update_and_upgrade;;
        "2" ) install_live_iso_dependencies;;
        "3" ) install_base;;
        "4" ) install_gaming;;
        "5" ) install_media;;
        "6" ) install_office;;
        "7" ) install_debs;;
        "8" ) transfer_settings;;
        "9" ) ./GET_PPA_REPOSITORIES.sh;;
        "10" ) ./GET_PPA_GPG_KEYS.sh;;
        "11" ) ./CLEANUP.sh;;
        "0" ) exit;;
        * ) echo "Don't know how you got here but that's a bad sign...";;
    esac

    main;
}


function update_and_upgrade() {
    apt-get update
    apt-get upgrade --no-install-recommends --no-install-suggests -y
}


function install_live_iso_dependencies() {
    # Adds ~30MB of stuff
    apt-get install -y casper lupin-casper
    # Adds ~25MB of stuff
    apt-get install -y discover laptop-detect os-prober
    # Adds ~55MB of stuff
    # In keeping with ubuntu-mini-remix structure I've added this here.
    # Might be a bad idea. (Actually really is a bad idea... as this should be manually called.)
    # This breaks from keeping things generic for it and debian. (Maybe? Could just fail an install.)
    apt-get install -y \
        ubuntu-minimal ubuntu-standard

    # The generic kernel can baloon a system with just the above
    # from ~130MB to 485+MB. (With good compression of squashfs)
    # Yet, we need A kernel in order to even boot stuff.
    # I need to look into a kind of menu for the user where they could chose one.
    # For right now, we'll use this...
    apt-get install -y linux-generic


    echo "Do you want to install one of the OS installers?"
    echo "\t1) ubiquity-frontend-gtk"
    echo "\t2) ubiquity-frontend-kde"
    echo "\t0) nethier..."
    read -p "--> : " ANSR
    while [[ $ANSR != "0" ]] && [[ $ANSR != "1" ]] && [[ $ANSR != "2" ]]; do
        read -p "--> : " ANSR
    done
    case $ANSR in
        "1" ) apt-get install --no-install-recommends --no-install-suggests -y \
                ubiquity-frontend-gtk;;
        "2" ) apt-get install --no-install-recommends --no-install-suggests -y \
                ubiquity-frontend-kde;;
        "0" ) return;;
    esac
}


# -------------------------------Bellow Installs the main system------------------------ #

######################## Main Desktop ########################
function install_base() {
    echo "Install base stuff stub..."
    #  Pushe to a meta-package deb after selecting what if anything you want to keep...
        # apt-get install -y xserver-xorg xorg xinit slim synaptic aptitude apt-xapian-index \
        # gufw wicd-curses pulseaudio pavucontrol file-roller p7zip-rar arj rar unrar-free \
        # xcompmgr tweak lhasa unar p7zip zip terminator stjerm ttf-mscorefonts-installer \
        # gparted gdebi sox udisks2 iftop htop tree hardinfo libsox-fmt-all onboard mc \
        # oracle-java8-installer apt-transport-https software-properties-common -y

        # apt-get autoremove --purge -y && apt-get autoclean

    #### Change bellow mate-core to other if one wants different window managers
    #### Above is mostly common base system stuff
        # apt-get install --no-install-recommends -y mate-core spacefm-gtk3 ulauncher
        # apt-get remove caja mate-terminal -y

    # This keeps packages that were marked for removal when we still want them...
    # I need to find the 'apt' version of this so as to divest from aptitude...
        # aptitude keep-all

    ############ Themes ############
}

############ Gaming ############
function install_gaming() {
    echo "Install gaming stuff stub..."
    # apt-get install --no-install-recommends --no-install-suggests -y \
    #     steam-launcher playonlinux dosbox
}

################### Multimedia-- Videos- Images- Etc ###################
function install_media() {
    echo "Install media stuff stub..."
    # apt-get install --no-install-recommends --no-install-suggests -y \
    #     blender bomi deadbeef gimp gimp-gap obs-studio xfce4-screenshooter \
    #     x264 mirage xchat-gnome guvcview
}

######################### Office-General Stuff #########################
function install_office() {
    echo "Install office stuff stub..."
    # apt-get install --no-install-recommends --no-install-suggests -y \
    #     filezilla qbittorrent quicksynergy synergy atom galculator \
    #     bleachbit gtkorphan libreoffice evince calibre
}

################### Look at DEB dirs to install software ####################

function install_debs() {
ARCH=$(uname -m)
touch COPY_OVER_TO_CHROOT/DEBS.sh

    if [[ "${ARCH}" == "i386" ]]; then
        ls COPY_OVER_TO_CHROOT/DEB32/ > COPY_OVER_TO_CHROOT/DEBS.sh
        ARCH="DEB32/"
    elif [[ "${ARCH}" == "x86_64" ]]; then
        ls COPY_OVER_TO_CHROOT/DEB64/ > COPY_OVER_TO_CHROOT/DEBS.sh
        ARCH="DEB64/"
    fi

    sed -i "s|^|dpkg -i ${ARCH}/|" COPY_OVER_TO_CHROOT/DEBS.sh
    bash COPY_OVER_TO_CHROOT/DEBS.sh
}

######################### Copy Settings to their locations #########################
function transfer_settings() {
    ## set etc skell
        rm -rf /etc/skel/
        cp -r COPY_OVER_TO_CHROOT/SETTINGS_THEMES/etc/skell/ /etc/

    ## set slim themes
        rm -rf /usr/share/slim/themes/
        mv COPY_OVER_TO_CHROOT/SETTINGS_THEMES/usr_share/slim/themes/ /usr/share/slim/

    ## set icons & themes
        cp -r COPY_OVER_TO_CHROOT/SETTINGS_THEMES/usr_share/icons /usr/share/
        cp -r COPY_OVER_TO_CHROOT/SETTINGS_THEMES/usr_share/themes /usr/share/

    ## set grub bg image
        echo 'GRUB_BACKGROUND="grub.jpg"' >> /etc/default/grub
        cp COPY_OVER_TO_CHROOT/SETTINGS_THEMES/boot_grub/grub.jpg /boot/grub/
        update-grub

}

main $@;
