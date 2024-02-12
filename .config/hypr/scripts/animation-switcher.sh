#!/usr/bin/env bash

# if it works - it works

toggle_opacity() {
	local hypr_rules="$HOME/.config/hypr/rules.conf"

	case "$1" in
		1)
			sed -i '0,/1/s/1/0.90/' "$hypr_rules"
			;;
		0)
			sed -i '0,/0.90/s/0.90/1/' "$hypr_rules"
	esac
	hyprctl reload
}

toggle_waybar () {
	local waybar_conf="$HOME/.config/waybar/style.css"
	local waybar_launch="$HOME/.config/waybar/launch.sh"

	case "$1" in
		1)
			sed -i '/border-radius/s/0/6/g' "$waybar_conf"
			;;
		0)
			sed -i '/border-radius/s/6/0/g' "$waybar_conf"
	esac

	nohup bash "$waybar_launch" &> /dev/null &
}

toggle_rofi() {
	local rofi_conf="$HOME/.config/rofi/config.rasi"
	local enabled_opacity="rgba(40, 40, 40, 0.85)"
	local disabled_opacity="rgb(40, 40, 40)"
	local regex="background-color"
	local regex_sec="border-radius"

	case "$1" in 
		1)
			sed -i "0,/$regex/s/$disabled_opacity/$enabled_opacity/" "$rofi_conf"
			# sed -i "/$regex_sec/s/0px/7px/g" "$rofi_conf"
			;;
		0)
			sed -i "0,/$regex/s/$enabled_opacity/$disabled_opacity/" "$rofi_conf"
			# sed -i "/$regex_sec/s/7px/0px/g" "$rofi_conf"
	esac
}

toggle_kitty() {
	kitty_conf="$HOME/.config/kitty/kitty.conf"
	
	case "$1" in
		1)
			sed -i '/background_opacity/s/1/0.90/' "$kitty_conf"
			;;
		0)
			sed -i '/background_opacity/s/0.90/1/' "$kitty_conf"
	esac
}

toggle_alacritty() {
	local alacritty_conf="$HOME/.config/alacritty/alacritty.yml"

	case "$1" in
		1)
			sed -i '/opacity/s/1/0.90/' "$alacritty_conf"
			;;
		0)
			sed -i '/opacity/s/0.90/1/' "$alacritty_conf"
	esac
}

toggle_hypr() {
	local hypr_conf="$HOME/.config/hypr/hyprland.conf"
	# local regex_first="rounding"
	local blur_string="$(grep -n 'enabled' "$hypr_conf" | awk 'NR==1{print $1}' | sed 's/://')"
	local anim_string="$(grep -n 'enabled' "$hypr_conf" | awk 'NR==2{print $1}' | sed 's/://')"
	
	case "$1" in
		1)
			sed -i "${blur_string}s/false/true/" "$hypr_conf"
			sed -i "${anim_string}s/no/yes/" "$hypr_conf"
			# sed -i "/$regex_first/s/0/4/" "$hypr_conf"
			;;
		0)
			sed -i "${blur_string}s/true/false/" "$hypr_conf"
			sed -i "${anim_string}s/yes/no/" "$hypr_conf"
			# sed -i "/$regex_first/s/4/0/" "$hypr_conf"
	esac
}

toggle_dunst() {
	local dunst_conf="$HOME/.config/dunst/dunstrc"
	local regex="corner_radius"

	case "$1" in
		1)
			# sed -i "/$regex/s/0/4/" "$dunst_conf"
			sed -i "/background/s/282828/28282897/" "$dunst_conf"
			;;
		0)
			# sed -i "/$regex/s/4/0/" "$dunst_conf"
			sed -i "/background/s/28282897/282828/" "$dunst_conf"
	esac
	killall dunst 
	nohup dunst &> /dev/null &
}

case "$1" in
	enable)
		toggle_kitty 1
		toggle_rofi 1
		# toggle_waybar 1
		toggle_dunst 1
		toggle_opacity 1
		toggle_hypr 1
		;;
	disable)
		toggle_kitty 0
		toggle_rofi 0
		# toggle_waybar 0
		toggle_dunst 0
		toggle_opacity 0
		toggle_hypr 0
esac

if pgrep -a bash | grep walls > /dev/null; then 
	kill "$(pgrep -a bash | grep walls | awk '{print $1}')"
	nohup bash "$HOME"/.config/hypr/scripts/dynamic-walls.sh &> /dev/null &
else
	nohup bash "$HOME"/.config/hypr/scripts/dynamic-walls.sh &> /dev/null &
fi
