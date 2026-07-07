#!/bin/bash

WAYBAR_PID=$(pidof waybar)
TRIGGER_WIDTH=12

pkill -RTMIN+3 waybar 2>/dev/null

while true; do
  read -r x y <<< "$(hyprctl cursorpos)"

  if [ "$x" -lt "$TRIGGER_WIDTH" ]; then
    pkill -RTMIN+2 waybar 2>/dev/null
  else
    pkill -RTMIN+3 waybar 2>/dev/null
  fi

  sleep 0.15
done
