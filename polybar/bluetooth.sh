#!/bin/bash

# A polybar module to show bluetooth status, using color to indicate on/off.
# This version includes a fix for the startup race condition.

# --- CONFIGURATION ---
# Colors from your polybar config
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
    # Get connected devices' information
    connected_devices_info=$(bluetoothctl devices Connected)

    # NEW: Check for the startup race condition where the output is the controller path
    if echo "$connected_devices_info" | grep -q "/org/bluez/hci0"; then
        # This is the race condition state. Treat as "On" but not yet connected.
        echo "%{F$COLOR_ON}$ICON%{F-} On"
    elif [[ -n "$connected_devices_info" ]]; then
        # A real device is connected
        device_name=$(echo "$connected_devices_info" | head -n1 | cut -d ' ' -f 3-)
        echo "%{F$COLOR_ON}$ICON%{F-} $device_name"
    else
        # Bluetooth is on but not connected to any device
        echo "%{F$COLOR_ON}$ICON%{F-} On"
    fi
else
    # --- BLUETOOTH IS OFF ---
    echo "%{F$COLOR_OFF}$ICON%{F-} Off"
fi
