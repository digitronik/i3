#!/bin/sh
# A zenity-based power menu for Polybar

# Use zenity to show a list of options
choice=$(zenity --list \
    --title="Power Menu" \
    --column="Action" \
    "Log Out" "Suspend" "Lock Screen" "Shut Down" "Reboot" \
    --width=150 --height=250 --hide-header)

# Use a case statement to handle the choice
case "$choice" in
    "Log Out")
        sh ~/.config/i3/lock.sh logout
        ;;
    "Suspend")
        sh ~/.config/i3/lock.sh suspend
        ;;
    "Lock Screen")
        sh ~/.config/i3/lock.sh lock
        ;;
    "Shut Down")
        sh ~/.config/i3/lock.sh shutdown
        ;;
    "Reboot")
        sh ~/.config/i3/lock.sh reboot
        ;;
esac

exit 0
