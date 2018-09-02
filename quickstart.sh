#!/bin/bash

# i3lock installation
sudo dnf i3lock

# Enable i3block copper repo else install with source code
sudo dnf -y copr enable wyvie/i3blocks
sudo dnf install i3blocks

# clear blocks created by i3blocks
sudo rm -rf /usr/libexec/i3blocks

# remove pre-config of i3
sudo rm -rf ~/.config/i3

# copy downloaded file to config
sudo cp -r ../ ~/.config/

# reload i3 now
echo
echo
echo
echo "####################################"
echo "Reaload configuration file for i3"
echo "mod(windows)+Shift+c"
echo "####################################"
