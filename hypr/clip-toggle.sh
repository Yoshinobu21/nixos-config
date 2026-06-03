#!/usr/bin/env bash

if pgrep -x "wl-paste" > /dev/null; then
    # If running, kill it for RDP mode
    pkill wl-paste
    notify-send "Clipboard Manager" "RDP Mode: Cliphist Watchers OFF" -u normal
else
    # If dead, start it for Local mode
    wl-paste --type text --watch cliphist store &
    wl-paste --type image --watch cliphist store &
    notify-send "Clipboard Manager" "Local Mode: Cliphist Watchers ON" -u normal
fi
