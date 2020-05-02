#!/bin/bash

main() {
install="Install AMD Drivers" 
unInstall="Uninstall AMD Drivers"
ansr=$(zenity --list --text "You can Install or Remove AMD Drivers Here. 
Please Note that if you Uninstall the propriatary drivers the generic drivers
will install in its stead.
" --radiolist  --column "Select" --column "Options" TRUE "Install AMD Drivers" FALSE "Uninstall AMD Drivers" --height 175);
if [[ "$ansr" == "$install" ]]; then
	zenity --info --text="Downloading AMD driver to /tmp as driver.zip..."
	curl -o /tmp/driver.zip http://www2.ati.com/drivers/linux/amd-catalyst-14-9-linux-x86-x86-64.zip --referer http://support.amd.com/en-us/kb-articles/Pages/Catalyst-Linux-Installer-Notes.aspx ;
	zenity --info --text="Unpacking driver from zip..."
	unzip /tmp/driver.zip -d /tmp/
	zenity --info --text="CDing to tmp driver folder and applying chmod +x to run file..."
	cd /tmp/fglr*
	chmod a+x *.run
	zenity --info --text="Running file from terminal..."
	terminator -x sudo sh *.run
	zenity --warning --text="Please Reboot now by pressing WinKey+R!"
elif [[ "$install" == "$unInstall" ]]; then
	zenity --info --text="Purging AMD* ..."
	gksu apt-get purge "fglrx.*" -y
	gksu rm /etc/X11/xorg.conf
	zenity --info --text="Installing generic video drivers ..."
	gksu apt-get install --reinstall xserver-xorg-core libgl1-mesa-glx:i386 libgl1-mesa-dri:i386 libgl1-mesa-glx:amd64 libgl1-mesa-dri:amd64	zenity --info --text="Cleaning System..."
	gksu apt-get autoremove --purge
	zenity --info --text="Reconfiguring system ..."
	sudo dpkg-reconfigure xserver-xorg
	zenity --warning --text="Please Reboot now by pressing WinKey+R!"
fi
}
main
