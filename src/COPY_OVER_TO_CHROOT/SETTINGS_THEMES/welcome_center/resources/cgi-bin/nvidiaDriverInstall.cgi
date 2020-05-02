#!/bin/bash

main() {
install="Install Nvidia Drivers" 
unInstall="Uninstall Nvidia Drivers"
ansr=$(zenity --list --text "You can Install or Remove Nvidia Drivers Here. 
Please Note that if you Uninstall the propriatary drivers the generic drivers
will install in its stead.
" --radiolist  --column "Select" --column "Options" TRUE "Install Nvidia Drivers" FALSE "Uninstall Nvidia Drivers" --height 175);
if [[ "$ansr" == "$install" ]]; then
	zenity --info --text="Adding ppa:xorg-edgers/ppa"
	gksu add-apt-repository ppa:xorg-edgers/ppa -y
	zenity --info --text="Updating..."
	gksu apt-get update
	zenity --info --text="Update Complete and now installing nvidia-346 nvidia-settings"
	gksu apt-get install nvidia-346 nvidia-settings -y
	zenity --warning --text="Please Reboot now by pressing WinKey+R!"
elif [[ "$install" == "$unInstall" ]]; then
	zenity --info --text="Purging nvidia* ..."
	gksu apt-get remove --purge nvidia* -y
	zenity --info --text="Removing ppa:xorg-edgers/ppa ..."
	gksu add-apt-repository -r ppa:xorg-edgers/ppa
	zenity --info --text="Cleaning System..."
	gksu apt-get autoremove --purge
	gksu rm /etc/X11/xorg.conf
	zenity --info --text="Installing libgl1-mesa-glx ..."
	gksu apt-get --reinstall install libgl1-mesa-glx
	zenity --warning --text="Please Reboot now by pressing WinKey+R!"
fi
}
main
