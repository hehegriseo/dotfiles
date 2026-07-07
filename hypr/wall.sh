#!/bin/bash

DIR="$HOME/Pictures/Wallpapers"

PICS=($(find "$DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \)))

if [ ${#PICS[@]} -eq 0 ]; then
    notify-send "Wallpaper Error" "No images found in $DIR"
    exit 1
fi

RANDOM_PIC="${PICS[$RANDOM % ${#PICS[@]}]}"

if ! swww query > /dev/null 2>&1; then
    swww-daemon --format xrgb &
    sleep 0.5
fi

# Smooth Outer Circle Grow Transition
swww img "$RANDOM_PIC" \
    --transition-type grow \
    --transition-pos center \
    --transition-step 90 \
    --transition-duration 1.5
