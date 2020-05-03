#!/bin/bash

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set




# ----  DO NOT CHANGE OR REMOVE UNLESS YOU KNOW WHAT YOU ARE DOING  ---- #

# ----  Setup Aliases  ---- #
shopt -s expand_aliases
alias echo="echo -e"

SCRIPT_PATH="$( cd "$(dirname "")" >/dev/null 2>&1 ; pwd -P )";




# ----  Methods Used Throughout The Process  ---- #

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
    echo "\t1)  Update & Upgrade"
    echo "\t2)  Install Core and Live ISO Dependencies"
    echo "\t3)  Install Base System Packages"
    echo "\t4)  Install Gaming Apps"
    echo "\t5)  Install Media Apps"
    echo "\t6)  Install Office Apps"
    echo "\t7)  Install Debs"
    echo "\t8)  Transfer Setting"
    echo "\t9)  Add PPA Repos"
    echo "\t10) Add PPA Repo Keys"
    echo "\t11) Cleanup (Should run before exiting chroot.)"
    echo "\t0) EXIT"
}
