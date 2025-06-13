#!/bin/bash

# A polybar module to show bluetooth status, using color to indicate on/off.
#
# Left-click: Toggles bluetooth power
# Right-click: Opens blueman-manager

COLOR_ON="#249824"      # Green (from colors.green)
COLOR_OFF="#D95B5B"     # Red (from colors.alert)

# Icon from Font Awesome 6 Brands font
ICON="%{T4}%{T-}" 
# ---------------------

# Handle the toggle action if the script is called with --toggle
if [[ "$1" == "--toggle" ]]; then
    if bluetoothctl show | grep -q "Powered: yes"; then
        bluetoothctl power off > /dev/null
    else
        bluetoothctl power on > /dev/null
    fi
    exit 0
fi

# Main logic to display status
if bluetoothctl show | grep -q "Powered: yes"; then
    # --- BLUETOOTH IS ON ---
    # The icon will now always be green when powered on.
    connected_devices=$(bluetoothctl devices Connected)

    if [[ -n "$connected_devices" ]]; then
        # On and Connected to a device
        device_name=$(echo "$connected_devices" | head -n1 | cut -d ' ' -f 3-)
        echo "%{F$COLOR_ON}$ICON%{F-} $device_name"
    else
        # On but not connected to any device
        echo "%{F$COLOR_ON}$ICON%{F-} On"
    fi
else
    # --- BLUETOOTH IS OFF ---
    # The icon will now be red when powered off.
    echo "%{F$COLOR_OFF}$ICON%{F-} Off"
fi