#!/bin/bash
# =============================================================================
# bluetooth.sh — Polybar module for Bluetooth status.
#
# Displays Bluetooth state with color-coded output. When a device is
# connected, shows its name. Handles the bluetoothctl startup race condition
# where 'devices Connected' may return a controller path instead of a device.
#
# Usage:
#   bluetooth.sh           Print status line for Polybar
#   bluetooth.sh --toggle  Toggle Bluetooth power on/off
# =============================================================================

COLOR_ON="#249824"
COLOR_OFF="#D95B5B"
ICON="%{T4}%{T-}"

if [[ "$1" == "--toggle" ]]; then
    if bluetoothctl show | grep -q "Powered: yes"; then
        bluetoothctl power off > /dev/null
    else
        bluetoothctl power on > /dev/null
    fi
    exit 0
fi

if bluetoothctl show | grep -q "Powered: yes"; then
    connected=$(bluetoothctl devices Connected)

    if echo "$connected" | grep -q "/org/bluez/hci0"; then
        # Startup race condition: controller path returned instead of device
        echo "%{F$COLOR_ON}$ICON%{F-} On"
    elif [[ -n "$connected" ]]; then
        device_name=$(echo "$connected" | head -n1 | cut -d ' ' -f 3-)
        echo "%{F$COLOR_ON}$ICON%{F-} $device_name"
    else
        echo "%{F$COLOR_ON}$ICON%{F-} On"
    fi
else
    echo "%{F$COLOR_OFF}$ICON%{F-} Off"
fi
