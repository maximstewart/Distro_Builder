#!/bin/bash

. CONFIG.sh

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set


# Debootstrap process
function main() {
    sudo debootstrap --arch=$ARCH $RELEASE "${CHROOT_PTH}"
}
main $@;
