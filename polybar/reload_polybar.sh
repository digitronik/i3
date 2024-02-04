#!/usr/bin/env bash

#/etc/NetworkManager/dispatcher.d/reload_polybar.sh

interface=$1
event=$2

echo $interface
echo $event

if [[ $interface == "tun0" ]] && [[ $event == "up" ]]; then
  sleep 1
  polybar-msg cmd restart > /dev/null
fi
