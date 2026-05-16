#!/bin/sh
# =============================================================================
# powermenu.sh — Zenity-based power menu for the Polybar power icon.
# =============================================================================

choice=$(zenity --list \
    --title="Power Menu" \
    --column="Action" \
    "Lock Screen" "Log Out" "Suspend" "Shut Down" "Reboot" \
    --width=150 --height=250 --hide-header)

case "$choice" in
    "Lock Screen") sh ~/.config/i3/lock.sh lock     ;;
    "Log Out")     sh ~/.config/i3/lock.sh logout   ;;
    "Suspend")     sh ~/.config/i3/lock.sh suspend  ;;
    "Shut Down")   sh ~/.config/i3/lock.sh shutdown ;;
    "Reboot")      sh ~/.config/i3/lock.sh reboot   ;;
esac
