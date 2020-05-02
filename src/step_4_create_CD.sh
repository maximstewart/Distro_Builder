#!/bin/bash

. CONFIG.sh

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set


function main() {
    echo "Creating the ISO file..."
    cd image/

    # Take note of the ending dot when changing this...
    sudo mkisofs -r -V "${OS_NAME}" -cache-inodes -J -l \
        -boot-info-table -no-emul-boot -boot-load-size 4 \
        -b isolinux/isolinux.bin -c isolinux/boot.cat \
        -o ../"${OS_NAME}".iso .

    cd ..
}

main $@;
