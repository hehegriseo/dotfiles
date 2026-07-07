#!/bin/bash

PROJECT_DIR="$HOME/projects"
if [ ! -d "$PROJECT_DIR" ]; then
    notify-send "Project Picker" "No ~/projects directory found"
    exit 1
fi

PROJECT=$(fd . "$PROJECT_DIR" --type d --max-depth 3 --exclude node_modules --exclude .git --exclude target --exclude venv --exclude .venv | tofi --prompt-text="open project >" --height 400)

if [ -n "$PROJECT" ]; then
    kitty --directory "$PROJECT" -e tmux
fi
