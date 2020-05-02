#!/bin/bash

main() {
install="Install Chromium"
unInstall="Uninstall Chromium"

ansr=$(zenity --list --text "You can Install or Remove Chromium here.
" --radiolist  --column "Select" --column "Options" TRUE "Install Chromium" FALSE "Uninstall Chromium" --height 175);
if [[ "$ansr" == "$install" ]]; then
					zenity --info --text="Installing Chromium..."
					terminator -x sudo apt-get install chromium-browser -y
					zenity --info --text="Install Completed!"
elif [[ "$ansr" == "$unInstall" ]]; then
					zenity --info --text="Purging Chromium* ..."
					terminator -x sudo apt-get remove --purge chromium-browser -y && \
         sudo apt-get autoremove --purge && \
         sudo apt-get autoclean
					zenity --info --text="Uninstall Completed!"
fi
}
main
