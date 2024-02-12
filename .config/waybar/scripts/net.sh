#!/usr/bin/env bash

command="$(nmcli connection show | awk 'NR=1 {print $1}' | sed -n '2p')"
icon="$HOME/.local/share/icons/custom/gruvbox-pack/wifi.png"
 
if [[ "$command" == "Wired" ]]; then 
	notify-send -i "$icon" "Network" "Wired connection"
else
	notify-send -i "$icon" "WiFi" "Connected to ${command}"
fi

