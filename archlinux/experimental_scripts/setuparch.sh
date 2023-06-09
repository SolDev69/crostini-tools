#!/usr/bin/env bash
USER_ID=$( id -u )
if [ $USER_ID == 0 ]
then
echo "This script will setup Arch Linux on Crostini."
read something
export DEFAULT_USER=$( grep 1000:1000 /etc/passwd|cut -d':' -f1 )
echo $DEFAULT_USER
if [ $DEFAULT_USER ]
then
echo "Please enter in the user name you wish to use."
read NEW_USER
pkill -9 -u $DEFAULT_USER
groupmod -n $NEW_USER $DEFAULT_USER
usermod -d /home/$NEW_USER -l $NEW_USER -m -c $NEW_USER $DEFAULT_USER
echo "Please enter your new user password."
passwd $NEW_USER
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/sudowheel
usermod -aG wheel $NEW_USER

pacman -Syu base-devel git dhclient xorg-xwayland wayland
dhcpcd eth0
systemctl disable systemd-networkd
systemctl disable systemd-resolved
unlink /etc/resolv.conf
touch /etc/resolv.conf
systemctl enable dhclient@eth0
systemctl start dhclient@eth0
echo "Please exit and log in to your new user from 'lxc console $HOSTNAME'"
else
echo "No user detected! This normally means you installed Arch from lxc."
echo "Please shut down your crostini install. Make sure your container is named 'penguin' and open the container from the Terminal app. When that gets to 'Starting Linux Container' close the terminal app and rerun this script as root."
fi
fi

if [ $USER_ID == 1000 ]
then
echo "Continuing setup..."
git clone https://aur.archlinux.org/cros-container-guest-tools-git.git
cd cros-container-guest-tools-git
makepkg -sfi
systemctl --user enable sommelier@0
systemctl --user enable sommelier@1
systemctl --user enable sommelier-x@0
systemctl --user enable sommelier-x@1
systemctl --user start sommelier@0
systemctl --user start sommelier@1
systemctl --user start sommelier-x@0
systemctl --user start sommelier-x@1
echo "Everything should be done. Please shut down linux by right clicking on the terminal app and clicking on 'Shut down Linux'"
fi
