#!/bin/bash

# Enable i3block copper repo else install with source code
sudo dnf -y copr enable wyvie/i3blocks
sudo dnf -y install i3blocks

# Clean by default scripts
sudo rm -rf /usr/libexec/i3blocks

# Monitor possition setting arandr
sudo dnf -y install arandr

# Terminal tilix
sudo dnf -y install tilix

# For laying out and rendering of text
sudo dnf -y install pango

# For notification
sudo dnf -y install dunst

# For Bluetooth
sudo dnf -y install blueman

# For wallpaper and picture viewer
sudo dnf -y install feh

# screen shooter for taking screenshot
sudo dnf -y install xfce4-screenshooter

# Power manger
sudo dnf -y install xfce4-power-manager

# reload i3 now
echo
echo
echo
echo "####################################"
echo "Reaload configuration file for i3"
echo "mod(windows)+Shift+c"
echo "####################################"
