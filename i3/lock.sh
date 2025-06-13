#!/bin/bash
# A script to handle locking and power operations, called by powermenu.sh

case "$1" in
    lock)
        i3lock -c 000000
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        i3lock -c 000000 && systemctl suspend
        ;;
    hibernate)
        i3lock -c 000000 && systemctl hibernate
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac

exit 0
