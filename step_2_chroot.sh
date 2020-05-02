#!/bin/bash

. CONFIG.sh

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set


# Debootstrap process
function main() {
    ansr=$(confirm_dialouge "Launch Xephyr preview window?\n Resolution: ${RES} Window ID: ${ID}")
    if [[ $ansr -eq 0 ]]; then
        Xephyr -resizeable -screen "${RES}" "${ID}" &
    fi

    sudo mount --bind /dev "${CHROOT_PTH}"/dev

    sudo cp /etc/hosts "${CHROOT_PTH}"/etc/hosts
    sudo cp /etc/resolv.conf "${CHROOT_PTH}"/etc/resolv.conf
    sudo sed s/$SYSTEM_RELEASE/$RELEASE/ < /etc/apt/sources.list > "${CHROOT_PTH}"/etc/apt/sources.list

    sudo chroot "${CHROOT_PTH}"

    # cleanup
    sudo umount "${CHROOT_PTH}"/dev


    # ----  OLD SETUP  ---- #
    # ## Set Xephyr and set chrooting mounts
    #     Xephyr -resizeable -screen "${RES}" "${ID}" &
    #     cd squashfs-root/
    #     mount -t proc proc proc/
    #     mount -t sysfs sys sys/
    #     mount -o bind /dev dev/
    #     cp /etc/resolv.conf etc/
    #
    # ##  Enter env with chroot
    #     chroot . bash
    #
    # ## Unmount binds
    #     umount -lf dev/
    #     umount -lf proc/
    #     umount -lf sys/
    #     cd ..



}
main $@;
