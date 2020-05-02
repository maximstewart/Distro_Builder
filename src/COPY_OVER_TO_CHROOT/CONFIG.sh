#!/bin/bash

. CONFIG_SCRIPTS.sh
. GET_PPA_GPG_KEYS.sh


# ----  Setup Variables  ---- #
export HOME=/root
export LC_ALL=C


# Screen-id of launched Xephyr on host system... ex:  :10  or :1.0, etc
# Note: Don't use :0 or :0.0 as they are your host system's.
export DISPLAY=:10


# ----  Call CONFIG_SCRIPTS Methods Here As Needed  ---- #
cd "${SCRIPT_PATH}";
echo "Base Dir: " $(pwd) "\n";
