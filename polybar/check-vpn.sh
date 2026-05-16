#!/bin/bash
# =============================================================================
# check-vpn.sh — Polybar module for VPN connection status.
#
# Checks for the presence of a tun0 interface (standard OpenVPN tunnel).
# Outputs a Polybar-formatted string with green VPN Active or red VPN Down.
# =============================================================================

INTERFACE="tun0"
COLOR_ACTIVE="#249824"
COLOR_DOWN="#D95B5B"

if ip addr show "$INTERFACE" > /dev/null 2>&1; then
    echo "%{u$COLOR_ACTIVE}%{+u}%{F$COLOR_ACTIVE}%{T3}%{T-}%{F-} VPN Active%{u-}"
else
    echo "%{F$COLOR_DOWN}%{T3}%{T-}%{F-} VPN Down"
fi
