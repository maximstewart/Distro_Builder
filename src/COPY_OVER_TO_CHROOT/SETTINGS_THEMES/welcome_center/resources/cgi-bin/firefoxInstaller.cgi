#!/bin/bash

main() {
install="Install Firefox"
unInstall="Uninstall Firefox"

ansr=$(zenity --list --text "You can Install or Remove Firefox here.
" --radiolist  --column "Select" --column "Options" TRUE "Install Firefox" FALSE "Uninstall Firefox" --height 175);
if [[ "$ansr" == "$install" ]]; then
					zenity --info --text="Installing Firefox..."
					gksu apt-get install firefox -y
					zenity --info --text="Install Completed!"
elif [[ "$ansr" == "$unInstall" ]]; then
					zenity --info --text="Purging Firefox* ..."
					gksu apt-get remove --purge firefox -y && \
          gksu apt-get autoremove --purge && \
          gksu apt-get autoclean
					zenity --info --text="Uninstall Completed!"
fi
}
main
