#!/usr/bin/env bash

# Calculate system boot time to parse Dunst's raw timestamps
boot_time=$(( $(date +%s) - $(cut -d. -f1 /proc/uptime) ))

# Fetch history, parse with jq, format it, and pipe to rofi
choice=$(dunstctl history | jq -j --argjson boot "$boot_time" '
  .data[0] | sort_by(.timestamp.data) | reverse | .[] |
  (
    ((($boot + (.timestamp.data / 1000000)) | floor | strflocaltime("%H:%M")) ) as $time |
    "[" + $time + "] " +
    (if .appname.data == "notify-send" then "System" else .appname.data end) +
    "\n" +
    .summary.data +
    (if (.body.data // "") != "" then " - " + .body.data else "" end) +
    "\u0000"
  )
' | rofi -dmenu \
  -config ~/.config/rofi/notif.rasi \
  -p "Alerts" \
  -sep '\0' \
  -eh 5)

# If an item was selected, copy it to the clipboard
if [ -n "$choice" ]; then
    echo "$choice" | wl-copy
fi
