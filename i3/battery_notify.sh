#!/bin/bash

# A script to send battery notifications

# Kill already running instances
killall -q "battery_notify.sh"

while true; do
    # Battery paths
    BATTERY_PATH="/sys/class/power_supply/BAT0"
    STATUS_PATH="$BATTERY_PATH/status"
    CAPACITY_PATH="$BATTERY_PATH/capacity"

    # Read values
    STATUS=$(cat "$STATUS_PATH")
    CAPACITY=$(cat "$CAPACITY_PATH")

    # Lock file to avoid spamming notifications
    LOCK_FILE="/tmp/battery_notification.lock"

    # Low battery threshold
    LOW_LEVEL=20

    # Full battery threshold
    FULL_LEVEL=98

    # --- Check for Low Battery ---
    if [ "$STATUS" = "Discharging" ] && [ "$CAPACITY" -le "$LOW_LEVEL" ]; then
        if [ ! -f "$LOCK_FILE" ] || [ "$(cat $LOCK_FILE)" != "low" ]; then
            notify-send -u critical -i "battery-low" "Battery Low!" "Plug in your charger. Remaining: ${CAPACITY}%"
            echo "low" > "$LOCK_FILE"
        fi

    # --- Check for Full Battery ---
    elif [ "$STATUS" = "Charging" ] && [ "$CAPACITY" -ge "$FULL_LEVEL" ]; then
        if [ ! -f "$LOCK_FILE" ] || [ "$(cat $LOCK_FILE)" != "full" ]; then
            notify-send -u normal -i "battery-full-charged" "Battery Full" "You can unplug your charger now. Level: ${CAPACITY}%"
            echo "full" > "$LOCK_FILE"
        fi

    # --- Reset Lock File when state changes ---
    elif [ "$STATUS" = "Charging" ] || [ "$STATUS" = "Full" ]; then
        # If it's charging but not yet full, or already full, we can reset the "low" lock
        if [ -f "$LOCK_FILE" ] && [ "$(cat $LOCK_FILE)" = "low" ]; then
             rm "$LOCK_FILE"
        fi
    elif [ "$STATUS" = "Discharging" ]; then
         # If it's discharging, we can reset the "full" lock
        if [ -f "$LOCK_FILE" ] && [ "$(cat $LOCK_FILE)" = "full" ]; then
             rm "$LOCK_FILE"
        fi
    fi

    # Wait for 60 seconds before checking again
    sleep 60
done
