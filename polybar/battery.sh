#!/bin/bash

battery_info=$(upower -i $(upower -e | grep BAT))
battery_level=$(echo "$battery_info" | grep "percentage:" | awk '{print $2}' | tr -d '%')
charging_status=$(echo "$battery_info" | grep "state:" | awk '{print $2}')
notification_sent_file="/tmp/battery_notification_sent"

if [ "$charging_status" == "charging" ]; then
    color="%{F#00FF00}"  # Green for charging
    icon=""  # Charging icon
else
    if [ "$battery_level" -lt 10 ] && [ ! -e "$notification_sent_file" ]; then
        notify-send -u critical "Low Battery" "Connect Charger (Currently at $battery_level%)"
        touch "$notification_sent_file"
    fi

    if [ "$battery_level" -lt 10 ]; then
        color="%{F#FF0000}"  # Red
    elif [ "$battery_level" -le 70 ]; then
        color="%{F#FFFF00}"  # Yellow
    else
        color="%{F#00FF00}"  # Green
    fi
    icon=""  # Discharging icon
fi

echo " $color$battery_level% $icon%{F-}"
