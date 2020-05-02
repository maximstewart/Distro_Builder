#!/bin/bash


# ----  Setup Aliases  ---- #
shopt -s expand_aliases
alias echo="echo -e"


# The system release version working from
function set_system_release() {
    IN=$(cat /etc/os-release | grep "VERSION_CODENAME")
    ARRY=(${IN//=/ })
    SYSTEM_RELEASE="${ARRY[1]}"
}


# ----  Setup Variables  ---- #


# Chroot path
CHROOT_PTH="./work/chroot"

# Resolution of Xephyr... ex: 1920x1080 or 1600x900, etc
RESOLUTION="1920x1080"

# Screen-id of Xephyr... ex:  :10  or :1.0, etc
# Note: Don't use :0 or :0.0 as they are your system's.
ID=":10"


# Your system release... this is set by set_system_release
# function above and can be safetly ignored
SYSTEM_RELEASE=""


# $RELEASE is the version of Ubuntu/Debian you intend to build an ISO for.
# Some options:  xenal, bionic, disco, focal
# Versions: xenal (16.0.4), bionic (18.04), disco (19.04), focal (20.04)
RELEASE=""

# $ARCH is the target processor architecture.
# For old 32 bit x86 systems use i386.
# For newer 64-bit x86 systems (also known as x64, x86_64, Intel 64, and AMD64) use amd64.
ARCH=""

# the name of your distro and ISO
OS_NAME=""

# The user of the live boot
LIVE_USER=""


# ----  Call CONFIG Methods Here As Needed  ---- #
set_system_release;


# ----  DO NOT CHANGE OR REMOVE UNLESS YOU KNOW WHAT YOU ARE DOING  ---- #

# Clean manifest-desktop file of unneeded parts
REMOVE='ubiquity ubiquity-frontend-gtk ubiquity-frontend-kde casper lupin-casper live-initramfs user-setup discover1 xresprobe os-prober libdebian-installer4'
