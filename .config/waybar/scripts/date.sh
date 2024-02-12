#!/usr/bin/env bash

DATE=$(date +"%A, the %d of %B")
NOTIFICATION_ICON="$HOME/.local/share/icons/custom/gruvbox-pack/calendar.png"

notify-send -r 3 -i "$NOTIFICATION_ICON" "$DATE"
