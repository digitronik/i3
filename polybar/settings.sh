#!/bin/sh
# A zenity-based settings menu for Polybar

choice=$(zenity --list \
    --title="Settings" \
    --column="Option" \
    "Audio" "Display" "Network Connections" "Wi-Fi Network" "Mouse and Keyboard" "Polybar Config" "i3 Config" \
    --width=200 --height=300 --hide-header)

case "$choice" in
    "Audio")
        pavucontrol
        ;;
    "Display")
        arandr
        ;;
    "Network Connections")
        nm-connection-editor
        ;;
    "Wi-Fi Network")
        # rofi-wifi-menu requires rofi to be installed
        rofi-wifi-menu
        ;;
    "Polybar Config")
        # Opens the file with your default text editor
        xdg-open ~/.config/polybar/config.ini
        ;;
    "i3 Config")
        # Opens the file with your default text editor
        xdg-open ~/.config/i3/config
        ;;
    "Mouse and Keyboard")
        # lxinput is part of lxappearance
        # sudo dnf install lxappearance
        lxinput
        ;;
esac

exit 0
