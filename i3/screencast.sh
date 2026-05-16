#!/bin/bash
# =============================================================================
# screencast.sh — Record a selected screen region as an animated GIF.
#
# Dependencies:
#   byzanz  : sudo dnf copr enable vishalvvr/byzanz && sudo dnf install byzanz
#   xrectsel: pip install --user python-xrectsel
#
# Usage: screencast.sh {start|stop|toggle}
# =============================================================================

OUTPUT_DIR="$HOME/Pictures"
DELAY=3
PIDFILE="/tmp/screencast_byzanz.pid"

usage() {
    echo "Usage: $(basename "$0") {start|stop|toggle}"
    echo ""
    echo "  start   Select a screen region and begin recording"
    echo "  stop    Stop the active recording and save the GIF"
    echo "  toggle  Start if idle, stop if recording (used for keybindings)"
    exit 1
}

beep() {
    paplay /usr/share/sounds/freedesktop/stereo/message-new-instant.oga &
}

start() {
    local time region
    time=$(date +"%Y-%m-%d-%H%M%S")
    sleep 1
    region=$(xrectsel -f "-x %x -y %y -w %w -h %h")
    notify-send "Screencast" "Recording starts in ${DELAY}s."
    sleep "$DELAY"
    beep
    byzanz-record --cursor --delay=1 ${region} "$OUTPUT_DIR/screencast-${time}.gif" &
    echo $! > "$PIDFILE"
}

stop() {
    if [ -f "$PIDFILE" ] && kill -0 "$(cat $PIDFILE)" 2>/dev/null; then
        kill "$(cat $PIDFILE)"
        rm -f "$PIDFILE"
        beep
        notify-send "Screencast" "Saved to $OUTPUT_DIR."
    fi
}

toggle() {
    if [ -f "$PIDFILE" ] && kill -0 "$(cat $PIDFILE)" 2>/dev/null; then
        stop
    else
        start
    fi
}

case "$1" in
    start)   start  ;;
    stop)    stop   ;;
    toggle)  toggle ;;
    *)       usage  ;;
esac
