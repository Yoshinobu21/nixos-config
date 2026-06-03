while inotifywait -e close_write ~/.config/waybar; do kill -SIGUSR2 $(pgrep waybar) || (pkill waybar && waybar &); done
