#!/bin/bash

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set


function main() {
    # ----  NOTE  ---- #
    # Add your keys here..
    # Command: sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys <key>
    # Ex: sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 283EC8CD
    echo "No gpg keys specified for addition..."
}
main $@;
