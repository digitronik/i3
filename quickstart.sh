#!/bin/bash

# Install requinments
sudo sh requirnments.sh
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
