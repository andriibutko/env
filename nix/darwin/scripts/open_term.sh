#!/usr/bin/env bash

if ! pgrep -f "Iterm" > /dev/null 2>&1; then
    open -a "/Applications/Iterm.app"
else
    # Create a new window
    script='tell application to create window with default profile'
    ! osascript -e "${script}" > /dev/null 2>&1 && {
        # Get pids for any app with" and kill
        while IFS="" read -r pid; do
            kill -15 "${pid}"
        done < <(pgrep -f "Iterm")
        open -a "/Applications/Iterm.app"
    }
fi