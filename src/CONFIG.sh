#!/bin/bash

. CONFIG_SCRIPTS.sh


# ----  Setup Variables  ---- #

# Resolution of Xephyr... ex: 1920x1080 or 1600x900, etc
RESOLUTION="1920x1080"

# Screen-id of Xephyr... ex:  :10  or :1.0, etc
# Note: Don't use :0 or :0.0 as they are your system's.
ID=":10"


# Your system release... this is set by set_system_release
# method from CONFIG_SCRIPTS.sh above and can be safetly ignored
SYSTEM_RELEASE=""


# $RELEASE is the version of Ubuntu/Debian you intend to build an ISO for.
# Some options:  xenal, bionic, disco, focal
# Versions: xenal (16.0.4), bionic (18.04), disco (19.04), focal (20.04)
RELEASE=""


# $ARCH is the target processor architecture.
# For old 32 bit x86 systems use i386.
# For newer 64-bit x86 systems (also known as x64, x86_64, Intel 64, and AMD64) use amd64.
ARCH=""

# The name and version of your distro and ISO
OS_NAME=""
OS_VER=""

# The user of the live boot
LIVE_USER=""




# ----  Call CONFIG_SCRIPTS Methods Here As Needed  ---- #
set_system_release;
cd "${SCRIPT_PATH}";
echo "Base Dir: " $(pwd) "\n";

# Make work structure
mkdir -p "${CHROOT_PTH}"
mkdir -p image/{casper,isolinux,install,boot,.disk}
touch image/ubuntu




# ----  DO NOT CHANGE OR REMOVE UNLESS YOU KNOW WHAT YOU ARE DOING  ---- #

# Clean manifest-desktop file of unneeded parts
REMOVE='ubiquity ubiquity-frontend-gtk ubiquity-frontend-kde casper lupin-casper live-initramfs user-setup discover1 xresprobe os-prober libdebian-installer4'
