#!/bin/bash

. CONFIG.sh

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set


function main() {
    sleep 2 # Used so we can see stub messages
    clear;
    start_menu_mesage;
    read -p "--> : " ANSR
    while $ANSR -lt 0 || $ANSR -gt 14; do
        read -p "--> : " ANSR
    done
    case $ANSR in
        "1" ) update_and_upgrade;;
        "2" ) install_live_iso_dependencies "ubuntu";;
        "3" ) install_live_iso_dependencies "debian";;
        "4" ) install_base;;
        "5" ) install_gaming;;
        "6" ) install_media;;
        "7" ) install_office;;
        "8" ) install_debs;;
        "9" ) transfer_settings;;
        "10" ) install_alsa;;
        "11" ) install_pulseaudio;;
        "12" ) ./GET_PPA_REPOSITORIES.sh;;
        "13" ) ./GET_PPA_GPG_KEYS.sh;;
        "14" ) ./CLEANUP.sh;;
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

    # Get the generic requsit packages.
    case $1 in
        "ubuntu" ) install_ubuntu_live_pkgs;;
        "debian" ) install_debian_live_pkgs;;
    esac

    install_installer

    # The generic kernel can baloon a system with just the above
    # from ~130MB to 460+MB. (With good compression of squashfs and cleaning)
    # Yet, we need A kernel in order to even boot stuff.
    # I need to look into a kind of menu for the user where they could chose one.
    # For right now, we'll use this...
    # apt-get install -y linux-generic
}

function install_ubuntu_live_pkgs() {
    # Adds ~55MB of stuff
    apt-get install -y \
        ubuntu-minimal ubuntu-standard
}

function install_debian_live_pkgs() {
    # Adds ~55MB of stuff {Maybe...I actually haven't checked that these exist}
    apt-get install -y \
        debian-minimal debian-standard
}

function install_alsa() {
    apt-get install -y \
        alsa* apulse sox libsox-fmt-all
}

function install_pulseaudio() {
    apt-get install -y \
        pulseaudio pavucontrol sox libsox-fmt-all
}


function install_installer() {

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
    # Note: Doing it this way, this actually is a small login manager that doesn't
    # bring in unity* packages. Slim is also a great choice and even smaller....
    # sudo apt-get install --no-install-recommends --no-install-suggests lightdm lightdm-gtk-greeter

    #  Push to a meta-package deb after selecting what if anything you want to keep...
        # apt-get install -y xserver-xorg xorg xinit slim synaptic aptitude apt-xapian-index \
        # gufw wicd-curses file-roller p7zip-rar arj rar unrar-free \
        # xcompmgr tweak lhasa unar p7zip zip terminator stjerm ttf-mscorefonts-installer \
        # gparted gdebi sox udisks2 iftop htop tree hardinfo onboard mc \
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
