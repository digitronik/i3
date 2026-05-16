#!/bin/bash
# =============================================================================
# launch.sh — Start Polybar, killing any existing instances first.
# Called by i3 via exec_always on login and every config reload.
# =============================================================================

killall -q i3bar
killall -q polybar

while pgrep -u "$UID" -x polybar > /dev/null; do sleep 1; done

sleep 1
polybar main -r &
