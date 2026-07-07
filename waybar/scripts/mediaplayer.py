#!/usr/bin/env python3
"""
Waybar mediaplayer script — shows currently playing track via playerctl.
Outputs JSON for waybar's custom/media module (continuous loop).
"""

import json
import subprocess
import sys
import time


def get_player_status():
    try:
        player = subprocess.check_output(
            ["playerctl", "--list-all"], stderr=subprocess.DEVNULL
        ).decode().strip().split("\n")[0]
        if not player:
            return None
    except (subprocess.CalledProcessError, IndexError):
        return None

    try:
        status = subprocess.check_output(
            ["playerctl", "-p", player, "status"], stderr=subprocess.DEVNULL
        ).decode().strip()
    except subprocess.CalledProcessError:
        return None

    try:
        title = subprocess.check_output(
            ["playerctl", "-p", player, "metadata", "title"],
            stderr=subprocess.DEVNULL
        ).decode().strip()
        artist = subprocess.check_output(
            ["playerctl", "-p", player, "metadata", "artist"],
            stderr=subprocess.DEVNULL
        ).decode().strip()
    except subprocess.CalledProcessError:
        title, artist = "Unknown", ""

    display = f"{artist} — {title}" if artist else title
    if len(display) > 45:
        display = display[:43] + "…"

    return {
        "text": display,
        "alt": player,
        "tooltip": f"{player}: {display}",
        "class": "paused" if status == "Paused" else "playing"
    }


def main():
    while True:
        result = get_player_status()
        if result:
            print(json.dumps(result), flush=True)
        else:
            print(json.dumps({"text": "", "class": "stopped"}), flush=True)
        time.sleep(2)


if __name__ == "__main__":
    main()
