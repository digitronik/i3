#!/bin/bash

# A script to check for an active VPN connection and display a Polybar module.
# This version shows a "down" status when not connected.

INTERFACE="tun0"

# Check if the tun0 interface exists using ip addr
if ip addr show "$INTERFACE" > /dev/null 2>&1; then
    # If it exists, print the "connected" format.
    # It will be green and underlined.
    # Icon:  (lock)
    echo "%{u#249824}%{+u}%{F#249824}%{T3}%{T-}%{F-} VPN Active%{u-}"
else
    # If it does not exist, print the "disconnected" format.
    # It will be red and not underlined.
    # Icon:  (unlock-alt)
    echo "%{F#D95B5B}%{T3}%{T-}%{F-} VPN Down"
fi
