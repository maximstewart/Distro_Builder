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
        "1" ) run_once_process;;
        "2" ) ./GET_PPA_REPOSITORIES.sh;;
        "3" ) ./GET_PPA_GPG_KEYS.sh;;
        "4" ) get_live_iso_dependencies;;
        "5" ) base;;
        "6" ) gaming;;
        "7" ) media;;
        "8" ) office;;
        "9" ) debs;;
        "10" ) transfer_settings;;
        "11" ) ./CLEANUP.sh;;
        "0" ) exit;;
        * ) echo "Don't know how you got here but that's a bad sign...";;
    esac
}


function run_once_process() {
    apt-get update
    apt-get install --yes dbus
    dbus-uuidgen > /var/lib/dbus/machine-id
    dpkg-divert --local --rename --add /sbin/initctl
    # Gets us add-apt-repository command
    apt-get install apt-transport-https software-properties-common -y
    apt-get --yes upgrade
}


function get_live_iso_dependencies() {
    apt-get install --yes casper lupin-casper
    apt-get install --yes discover laptop-detect os-prober
    apt-get install --yes linux-generic

    echo "Do you want to install?"
    echo "\t1) ubiquity-frontend-gtk"
    echo "\t2) ubiquity-frontend-kde"
    echo "\t0) nethier..."
    read -p "--> : " ANSR
    while [[ $ANSR != "0" ]] && [[ $ANSR != "1" ]] && \
                                [[ $ANSR != "2" ]]; do
        read -p "--> : " ANSR
    done
    case $ANSR in
        "0" ) apt-get install --yes ubiquity-frontend-gtk --no-install-recommends --no-install-suggests
                break;;
        "1" ) apt-get install --yes ubiquity-frontend-kde --no-install-recommends --no-install-suggests
                break;;
        "2" ) break;;
    esac
}


#-------------------------------Bellow Installs the main system------------------------#

######################## Main Desktop ########################
function base() {
#  Pushed to a meta-package deb
    # apt-get install xserver-xorg xorg xinit slim synaptic aptitude apt-xapian-index \
    # gufw wicd-curses pulseaudio pavucontrol file-roller p7zip-rar arj rar unrar-free \
    # xcompmgr tweak lhasa unar p7zip zip terminator stjerm ttf-mscorefonts-installer \
    # gparted gdebi sox udisks2 iftop htop tree hardinfo libsox-fmt-all onboard mc \
    # oracle-java8-installer -y

apt-get autoremove --purge -y && apt-get autoclean

####  Change bellow mate-core to other if
####  one wants different window managers
#### Above is mostly common base system stuff
    apt-get install mate-core spacefm-gtk3 --no-install-recommends ulauncher -y
    apt-get remove caja mate-terminal -y
    aptitude keep-all

############ Themes ############
    # apt-get install paper-gtk-theme paper-icon-theme \
    #                 sable-gtk mate-icon-theme -y
}

############ Gaming ############
function gaming() {
    apt-get --no-install-recommends --no-install-suggests install \
        steam-launcher playonlinux dosbox -y
}

################### Multimedia-- Videos- Images- Etc ###################
function media() {
# guvcview
    apt-get --no-install-recommends --no-install-suggests install blender \
        bomi deadbeef gimp gimp-gap obs-studio xfce4-screenshooter x264 mirage \
        xchat-gnome -y
}

######################### Office-General Stuff #########################
function office() {
# calibre
    apt-get --no-install-recommends --no-install-suggests install  \
        filezilla qbittorrent quicksynergy synergy atom galculator bleachbit \
        gtkorphan libreoffice evince -y

debs
}

################### Look at DEB dirs to install software ####################

function debs() {
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
