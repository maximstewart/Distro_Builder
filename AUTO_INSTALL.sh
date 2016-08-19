#---------------- Copyright notices and creator info-----------------------------#
#
# By Maxim F. Stewart Contact: [maxim2131@gmail.com] OR [gamer1119@gmail.com]
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
setup() {
export HOME=/root
export LC_ALL=C
export DISPLAY=:10

cat COPY_OVER_TO_CHROOT/PPA_LIST.txt > /etc/apt/sources.list
bash COPY_OVER_TO_CHROOT/PPA_GPG.sh
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4B4E7A9523ACD201  ## get MEGA gpg key

#-------------------------------Bellow adds other PPAs----------------------------------#
apt-get update
apt-get install apt-transport-https software-properties-common -y  ## Get add-apt-repository

## INSERT PPA ADDS HEDRE

apt-get update &&  apt-get upgrade -y
main
}
#-------------------------------Bellow Installs the main system------------------------#

######################## Main Desktop ########################
main() {
## MOSTLY BASE SYSTEM PROGRAMS | Might wish to use another internet manager
## besides Wicd-gtk and might not want to use Slim as a login manager
    apt-get install xserver-xorg xorg xinit slim synaptic aptitude apt-xapian-index \
    gufw wicd-gtk pulseaudio pavucontrol file-roller p7zip-rar arj rar unrar-free \
    xcompmgr tweak lhasa unar p7zip zip terminator stjerm gparted gdebi sox udisks2 \
    iftop htop tree hardinfo libsox-fmt-all onboard mc  -y

    apt-get autoremove --purge -y && apt-get autoclean

gaming
}

############ Gaming ############
gaming() {
## INSERT GAMING STUFF HEDRE

media
}

################### Multimedia-- Videos- Images- Etc ###################
media() {
## INSERT MEDIA STUFF HEDRE

office
}

######################### Office-General Stuff #########################
office() {
## INSERT OFFICE & OTHER STUFF HEDRE

debs
}

################### Looks at DEB32/64 dirs to install software ####################
## INSERT GAMING STUFF HEDRE
debs() {
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

setSettings
}

######################### Copy Settings to their locations #########################
setSettings() {

## COPY/REMOVE SETTING FIES HERE
## Fine tune the system

cleanr
}

######################### Cleanup System #########################
cleanr() {
    apt-get autoremove --purge -y
    apt-get autoclean -y
    aptitude keep-all -y
    rm -rf COPY_OVER_TO_CHROOT/
    clear
    echo ""
    echo ""
    echo "Please remove this scrit then type exit to continue build..."
    echo ""
    echo ""
}
setup
