#!/bin/bash

# --------------------------------------- Prerequisite --------------------------------------------
# 1. byzanz 
#		sudo dnf copr enable vishalvvr/byzanz	# for fedora
#		sudo dnf install byzanz -y
# 2. xrectsel
#		pip install python-xrectsel --user
# -------------------------------------------------------------------------------------------------

TIME=$(date +"%Y-%m-%d-%H%M%S")
FOLDER="$HOME/Pictures"
DELAY=3

# Help msg
help() {
  echo "
  ${bold}Screencast${normal}
  Record screen with byzanz-record and python-xrectsel in gif format.

  ${bold}Usage${normal}: screencast [command]

  ${bold}Commands${normal}:
  start    Start recording
  stop	   Stop recording
  toggle   Toggling between start and stop.
           Specially used for single key binding for start and stop screencast
  *         Help
  "
  exit 1
}

# Notification sound
beep() {
    paplay /usr/share/sounds/freedesktop/stereo/message-new-instant.oga &
}

# Start recording with byzanz-record and xrectsel
start() {
    # Find region with xrectsel
    sleep 1
    echo "Select region"
    REGION=$(xrectsel -f "-x %x -y %y -w %w -h %h")
    echo "Recording will start in $DELAY seconds."
    notify-send "Screencast:" "recording will start in $DELAY seconds."
    sleep $DELAY
    beep
	  # start recording with byzanz recorder
    byzanz-record --cursor --exec 'sleep 1000000' --delay=1 ${REGION} "$FOLDER/screencast-$TIME.gif"&
}

# Stop recording
stop() {
    if pgrep -x sleep >/dev/null
    then
        killall sleep
        beep
        echo "Screencast: saved to $FOLDER."
        notify-send "Screencast:" "saved to $FOLDER."
    fi
}

# Toggle mode for binding specific key to start and stop
toggle() {
    if pgrep -x sleep >/dev/null
    then
      stop
    else
      start
    fi
}

case "$1" in
    start)
      start
      ;;
    stop)
      stop
      ;;
    toggle)
      toggle
      ;;
    *)
      help
      ;;
esac
