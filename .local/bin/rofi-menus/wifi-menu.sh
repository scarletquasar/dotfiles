#!/usr/bin/env bash

ICON_WIFI="$HOME/.local/share/icons/custom/gruvbox-pack/wifi.png"
ICON_SUCCES="$HOME/.local/share/icons/custom/gruvbox-pack/succes.png"

notify-send -r 996 -i "$ICON_WIFI" "Getting Wi-Fi networks..."

WIFI_LIST=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")
notify-send -r 996 -i "$ICON_SUCCES" "Done"

CONNECTED=$(nmcli -fields WIFI g)
if [[ "$CONNECTED" =~ "enabled" ]]; then
	TOGGLE="󰖪  Disable Wi-Fi"
elif [[ "$CONNECTED" =~ "disabled" ]]; then
	TOGGLE="󰖩  Enable Wi-Fi"
fi

CHOSEN_NETWORK=$(echo -e "$TOGGLE\n$WIFI_LIST" | uniq -u | rofi -dmenu -theme "$HOME"/.config/rofi/config.rasi -hover-select -no-show-icons)
CHOSEN_ID=$(echo "${CHOSEN_NETWORK:3}" | xargs)

if [ "$CHOSEN_NETWORK" = "" ]; then
	exit
elif [ "$CHOSEN_NETWORK" = "󰖩 Enable Wi-Fi" ]; then
	nmcli radio wifi on
elif [ "$CHOSEN_NETWORK" = "󰖪  Disable Wi-Fi" ]; then
	nmcli radio wifi off
else
	SAVED_CONNECTIONS=$(nmcli -g NAME connection)
	if [[ $(echo "$SAVED_CONNECTIONS" | grep -w "$CHOSEN_ID") = "$CHOSEN_ID" ]]; then
		nmcli connection up id "$CHOSEN_ID" | grep "successfully" && notify-send -i "$ICON_SUCCES" "Connected"
	else
		if [[ "$CHOSEN_NETWORK" =~ "" ]]; then
			WIFI_PASSWORD=$(rofi -dmenu -password -theme "$HOME"/.config/rofi/config.rasi -hover-select -no-show-icons)
		fi
		nmcli device wifi connect "$CHOSEN_ID" password "$WIFI_PASSWORD" | grep "successfully" && notify-send -i "$ICON_SUCCES" "Connected"
	fi
fi


