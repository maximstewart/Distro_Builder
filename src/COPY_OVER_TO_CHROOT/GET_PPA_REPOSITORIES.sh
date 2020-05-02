#!/bin/bash

. CONFIG.sh

# set -o xtrace       ## To debug scripts
# set -o errexit      ## To exit on error
# set -o errunset     ## To exit if a variable is referenced but not set


# ----  Bellow adds other PPAs  ---- #
function main() {
    echo "No ppas specified for addition..."
    ####### SOFTWARE PPAs #######
    # add-apt-repository ppa:webupd8team/atom -y # atom text editor
    # apt-add-repository ppa:obsproject/obs-studio -y # open broadcaster studio
    # add-apt-repository ppa:starws-box/deadbeef-player -y # deadbeef musuc player

    ####### THEMES PPAs #######
    # add-apt-repository ppa:noobslab/themes -y  # sable-gtk
    # add-apt-repository ppa:noobslab/icons2 -y # more icons
    # add-apt-repository ppa:snwh/pulp -y    # paper-gtk-theme
    # apt-get install ambiance-blackout-colors -y # ambiance-blackout-colors
}
main $@;
