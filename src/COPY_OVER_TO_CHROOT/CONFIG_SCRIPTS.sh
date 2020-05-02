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
    echo "\t1)  Run the initial environment setup process (Only run once!)"
    echo "\t2)  Add PPA repos"
    echo "\t3)  Pull PPA repo keys"
    echo "\t4)  Install live ISO dependencies"
    echo "\t5)  Install Base System Packages"
    echo "\t6)  Install Gaming Apps"
    echo "\t7)  Install Media Apps"
    echo "\t8)  Install Office Apps"
    echo "\t9)  Install Debs"
    echo "\t10) Transfer Setting"
    echo "\11) Cleanup (Should run before exiting chroot.)"
    echo "\t0) EXIT"
}
