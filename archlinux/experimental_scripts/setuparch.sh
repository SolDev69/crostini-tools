#!/usr/bin/env bash
USER_ID=$( id -u )
if [ $USER_ID == 0 ]
then
echo "This script will setup Arch Linux on Crostini."
read
export DEFAULT_USER=$( grep 1000:1000 /etc/passwd|cut -d':' -f1 )
if [ ! $DEFAULT_USER ]
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
echo "Please exit and log in to your new user from `lxc console $HOSTNAME`"
else
echo "No user detected! This normally means you installed Arch from lxc, which currently isn't supported. I will likely update this script with support soon, but for now please delete this container and from a new crosh shell run `vmc container termina $HOSTNAME https://us.lxd.images.canonical.com/ archlinux/current`"
fi
fi

if [ $USER_ID == 1000 ]
then
echo "Continuing setup..."
git clone https://aur.archlinux.org/cros-container-guest-tools-git.git
cd cros-container-guest-tools-git
echo "[Unit]
After=network-online.target
Wants=network-online.target
ConditionPathExists=/dev/.container_token" > cros-garcon-conditions.conf
DEFAULT_HASH=d326cd35dcf150f9f9c8c7d6336425ec08ad2433
sed -i "s/$DEFAULT_HASH/SKIP/gi" PKGBUILD
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
