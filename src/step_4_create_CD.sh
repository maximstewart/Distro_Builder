#!/bin/bash

. CONFIG.sh

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set


function main() {
    echo "Creating the ISO file..."
    cd image/
    sudo mkisofs -r -V "${OS_NAME}" -cache-inodes -J -l \
        -b isolinux/isolinux.bin \
        -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
        -boot-info-table -o ../"${OS_NAME}".iso .
    cd ..
}

main $@;
