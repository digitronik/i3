#!/bin/bash

# Do your setup
sudo dnf update
sudo dnf install -y ansible git
ansible-playbook -K setup.yml

# remove pre-config of i3
sudo mv ../i3 ~/.config/i3

# reload i3 now
echo
echo
echo
echo "####################################"
echo "Reaload configuration file for i3"
echo "mod(windows)+Shift+c"
echo "####################################"
