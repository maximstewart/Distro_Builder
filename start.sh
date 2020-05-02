#!/bin/bash

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set


. CONFIG.sh

function main() {
    sanity_check
    if [[ $? -eq 1 ]]; then echo "\nExiting..."; return; fi

    # First setup the debootstrap env...
    ./step_1_debootstrap.sh
    # Then setup and run chroot
    # ./step_2_chroot.sh

}


function sanity_check() {
    clear;
    SCRIPTPATH="$( cd "$(dirname "")" >/dev/null 2>&1 ; pwd -P )";
    cd "${SCRIPTPATH}";
    echo "Working Dir: " $(pwd) "\n";

    # Make work structure
    mkdir -p work/chroot ;

    # Check for debootstrap command and then install from downloaded deb if not present.
    # we could install from current apt buti want the user and myself to be fully aware
    # of what they are chosing. IE, they could just run the install command themselves...
    debootstrap_comm=$(which debootstrap)
    if [[ "${debootstrap_comm}" == "" ]]; then
        echo "No deboostrap command found so will try installing from local directory...\n"
        if [[ ! -f "debootstrap.deb" ]]; then
            echo "No debootstrap deb file found in current directory...";
            echo "Please download one from:\n\thttps://packages.ubuntu.com/search?keywords=debootstrap&searchon=names&suite=all&section=all";
            echo "After download rename it to:  debootstrap.deb\n";
            echo "OR\n"
            echo "Run:  sudo apt install debootstrap"
            return 1;
        else
            sudo dpkg -i ./deboostrap.deb
        fi
    fi

    xyphr=$(which Xephyr)        ## Chroot view window || alt desktop window
    sysLnx=$(which syslinux)     ## Casper stuff
    squash=$(which unsquashfs)   ## Squashfs-tools
    genIso=$(which genisoimage)  ## Iso maker
    if [[ $xyphr == "" ]] || [[ $sysLnx == "" ]] || \
       [[ $squash == "" ]] || [[ $genIso == "" ]]; then
        echo "# ----  Missing Some Packages  ---- #\n" \
                "Xephyr :" "${xyphr}\n" \
                "Syslinux :" "${sysLnx}\n" \
                "Squashfs-tools :" "${squash}\n" \
                "Genisoimage :" "${genIso}\n" \
                "Going to run :\n" \
                "\tapt-get install xserver-xephyr syslinux squashfs-tools genisoimage -y"
        sleep 2
        apt-get install xserver-xephyr syslinux squashfs-tools genisoimage -y
    fi

    if [[ "${ARCH}" == "" ]] || [[ "${RELEASE}" == "" ]]; then
        echo "Please check CONFIG.sh and set the ARCH and RELEASE data...";
        return 1;
    fi

    if [[ "${OS_NAME}" == "" ]] || [[ "${LIVE_USER}" == "" ]]; then
        echo "Please check CONFIG.sh and set the OS_NAME and LIVE_USER data...";
        return 1;
    fi

    return 0;
}


main $@;
