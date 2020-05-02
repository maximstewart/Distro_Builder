#!/bin/bash

. CONFIG.sh

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set


# Debootstrap process
function main() {
    confirm_dialouge "Launch Xephyr preview window?\n Resolution: ${RESOLUTION} Window ID: ${ID}"
    if [[ $? -eq 0 ]]; then
        Xephyr -resizeable -screen "${RES}" "${ID}" &
    fi

    clear
    # Mount stuff
    sudo mount --bind /dev "${CHROOT_PTH}"/dev/
    sudo mount -t proc proc "${CHROOT_PTH}"/proc/
    sudo mount -t sysfs sys "${CHROOT_PTH}"/sys/

    # setup some configs stuff for internetz
    sudo cp -r COPY_OVER_TO_CHROOT/ "${CHROOT_PTH}"
    sudo cp /etc/hosts "${CHROOT_PTH}"/etc/hosts
    sudo cp /etc/resolv.conf "${CHROOT_PTH}"/etc/resolv.conf
    sudo chown $USER "${CHROOT_PTH}"/etc/apt/sources.list
    sudo sed s/$SYSTEM_RELEASE/$RELEASE/ < /etc/apt/sources.list > "${CHROOT_PTH}"/etc/apt/sources.list
    sudo chown root "${CHROOT_PTH}"/etc/apt/sources.list

    # Enter chroot mode
    chroot_big_dump_mesage
    sudo chroot "${CHROOT_PTH}"

    # cleanup
    sudo rm -rf "${CHROOT_PTH}"/COPY_OVER_TO_CHROOT/
    sudo umount "${CHROOT_PTH}"/dev/
    sudo umount -lf "${CHROOT_PTH}"/proc/
    sudo umount -lf "${CHROOT_PTH}"/sys/
}
main $@;
