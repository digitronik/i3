#!/bin/bash

# i3lock installtion
sudo dnf i3lock

# Enable i3block copper repo else install with source code
sudo dnf -y copr enable wyvie/i3blocks
sudo dnf install i3blocks

# Monitor possition setting arandr
sudo dnf install arandr

# Terminal tilix
sudo dnf install tilix

# For laying out and rendering of text
sudo dnf install pango

# For notification
sudo dnf install dunst

# For bluetooth
sudo dnf install blueman

# For wallpaper and picture viewer
sudo dnf install feh

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
