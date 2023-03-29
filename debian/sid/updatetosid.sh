#!/bin/sh

echo "Warning, this script will upgrade your Crostini install from Debian Bullseye to Debian Sid. Things may break in the long run, backup all important data as debian sid can be more unstable than arch sometimes."
read
echo "Updating system"
sudo apt update
sudo apt upgrade -y

echo "Update to Sid"
sudo echo "deb https://deb.debian.org/debian sid main contrib" > /etc/apt/sources.list
sudo apt update
sudo apt upgrade -y

echo "Installing updated/patched packages"
sudo apt install ./cros-im-fixed.deb libwacom-common

echo "Remove useless packages"
sudo apt autopurge

echo "Done. Please restart Crostini by right clicking on the terminal app and clicking 'Shut down linux'."
