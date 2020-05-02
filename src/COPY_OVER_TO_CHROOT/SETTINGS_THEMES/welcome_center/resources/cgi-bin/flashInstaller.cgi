#!/bin/bash

main() {
install="Install Flash"
unInstall="Uninstall Flash"

ansr=$(zenity --list --text "You can Install or Remove Flash here.
" --radiolist  --column "Select" --column "Options" TRUE "Install Flash" FALSE "Uninstall Flash" --height 175);
if [[ "$ansr" == "$install" ]]; then
	zenity --info --text="Installing Flash..."
	gksu apt-get install flashplugin-installer -y
	zenity --info --text="Install Completed! Please restart your browsers."
elif [[ "$ansr" == "$unInstall" ]]; then
	zenity --info --text="Purging Flash* ..."
	gksu apt-get remove --purge flashplugin-installer -y
	zenity --info --text="Uninstall Completed! Please restart your browsers."
fi
}
main
