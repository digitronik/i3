#!/bin/sh
# =============================================================================
# settings.sh — Zenity-based settings menu for the Polybar gear icon.
# =============================================================================

choice=$(zenity --list \
    --title="Settings" \
    --column="Option" \
    "Audio" "Display" "Network Connections" "Wi-Fi Network" \
    "Mouse and Keyboard" "Polybar Config" "i3 Config" \
    --width=200 --height=300 --hide-header)

case "$choice" in
    "Audio")               pavucontrol                           ;;
    "Display")             arandr                                ;;
    "Network Connections") nm-connection-editor                  ;;
    "Wi-Fi Network")       rofi-wifi-menu                        ;;
    "Polybar Config")      xdg-open ~/.config/polybar/config.ini ;;
    "i3 Config")           xdg-open ~/.config/i3/config          ;;
    "Mouse and Keyboard")  lxinput                               ;;
esac
