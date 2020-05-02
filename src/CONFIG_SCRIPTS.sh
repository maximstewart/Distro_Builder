#!/bin/bash

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set




# ----  DO NOT CHANGE OR REMOVE UNLESS YOU KNOW WHAT YOU ARE DOING  ---- #

# ----  Setup Aliases  ---- #
shopt -s expand_aliases
alias echo="echo -e"

SCRIPT_PATH="$( cd "$(dirname "")" >/dev/null 2>&1 ; pwd -P )";
CHROOT_PTH="./work/chroot"




# ----  Methods Used Throughout The Process  ---- #
# Help get the system release version we're working from
function set_system_release() {
    IN=$(cat /etc/os-release | grep "VERSION_CODENAME")
    ARRY=(${IN//=/ })
    SYSTEM_RELEASE="${ARRY[1]}"
}


# Generic confirm 'dialouge'
function confirm_dialouge() {
    echo $1
    read -p "(yY/Nn) --> " ANSR
    while [[ $ANSR != "y" ]] && [[ $ANSR != "Y" ]] && \
          [[ $ANSR != "n" ]] && [[ $ANSR != "N" ]]
    do
        read -p "(yY/Nn) --> " ANSR
    done

    if [[ $ANSR == "n" ]] || [[ $ANSR == "N" ]]; then
        return 1
    fi

    return 0
}




# ----  Messages Used Throughout The Process  ---- #

function start_menu_mesage() {
    echo "NOTE: Remember to check the CONFIG.sh and set the variables!"
    echo "\nWhat do you want to run?"
    echo "\t1) Do all jobs (Including cleanup berfore starting.)"
    echo "\t2) Do debootstrap run"
    echo "\t3) Chroot"
    echo "\t4) Create boot structure"
    echo "\t5) Create the ISO"
    echo "\t6) Cleanup (Purges everything that was generated.)"
    echo "\t0) EXIT"
}

function chroot_big_dump_mesage() {
    echo "NOTE: COPY_OVER_TO_CHROOT is removed after exit from chroot env."
    echo "\nRun each time you chroot:"
    echo "\texport HOME=/root"
    echo "\texport LC_ALL=C"
    echo "\nRun once in chroot:"
    echo "\tapt-get update"
    echo "\tapt-get install --yes dbus"
    echo "\tdbus-uuidgen > /var/lib/dbus/machine-id"
    echo "\tdpkg-divert --local --rename --add /sbin/initctl"
    echo "\tapt-get --yes upgrade"

    echo "Note: You probably should copy to a notepad the following..."
    echo "\nThere is a current (for Karmic, ..., Precise) issue with services running in a chroot:"
    echo "\thttps://bugs.launchpad.net/ubuntu/+source/upstart/+bug/430224."
    echo "\nA workaround is to link /sbin/initctl to /bin/true:"
    echo "\tln -s /bin/true /sbin/initctl"

    echo "\nInstall packages needed for Live System (I think 'ubuntu-standard' package is optional.):"
    echo "\tapt-get install --yes casper lupin-casper"
    echo "\tapt-get install --yes discover laptop-detect os-prober"
    echo "\nTo actually install the system you'll need one of the following or something similar..."
    echo "\tapt-get install --yes linux-generic"
    echo "\tapt-get install --yes ubiquity-frontend-gtk"
    echo "\t\tOR"
    echo "\tapt-get install --yes ubiquity-frontend-kde"
}