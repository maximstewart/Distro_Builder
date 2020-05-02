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

function chroot_big_dump_mesage() {
    echo "Run each time you chroot:"
    echo "\texport HOME=/root"
    echo "\texport LC_ALL=C"
    echo "\nRun once in chroot:"
    echo "\tapt-get update"
    echo "\tapt-get install --yes dbus"
    echo "\tapt-get --yes upgrade"
    echo "\tdbus-uuidgen > /var/lib/dbus/machine-id"
    echo "\tdpkg-divert --local --rename --add /sbin/initctl"

    echo "\nThere is a current (for Karmic, ..., Precise) issue with services running in a chroot:"
    echo "\thttps://bugs.launchpad.net/ubuntu/+source/upstart/+bug/430224."
    echo "\nA workaround is to link /sbin/initctl to /bin/true:"
    echo "\tln -s /bin/true /sbin/initctl"

    echo "\nInstall packages needed for Live System (I think 'ubuntu-standard' package is optional.):"
    echo "\tapt-get install --yes casper lupin-casper"
    echo "\tapt-get install --yes discover laptop-detect os-prober"
    echo "\tapt-get install --yes linux-generic"
}
