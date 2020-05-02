#!/bin/bash

main() {
install="Install Opera"
unInstall="Uninstall Opera"

ansr=$(zenity --list --text "You can Install or Remove Opera here.
" --radiolist  --column "Select" --column "Options" TRUE "Install Opera" FALSE "Uninstall Opera" --height 175);
if [[ "$ansr" == "$install" ]]; then
					zenity --info --text="Installing Opera..."
     wget -P /tmp/ "http://download1.operacdn.com/pub/opera/desktop/36.0.2130.65/linux/opera-stable_36.0.2130.65_amd64.deb"
					terminator -x sudo gdebi "/tmp/opera-stable_36.0.2130.65_amd64.deb"
					zenity --info --text="Install Completed!"
elif [[ "$ansr" == "$unInstall" ]]; then
					zenity --info --text="Purging Opera* ..."
     wget -P /tmp/ "http://download1.operacdn.com/pub/opera/desktop/36.0.2130.65/linux/opera-stable_36.0.2130.65_amd64.deb"
					terminator -x sudo gdebi "/tmp/opera-stable_36.0.2130.65_amd64.deb"
					zenity --info --text="Uninstall Completed!"
fi
}
main
