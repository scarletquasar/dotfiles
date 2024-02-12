#!/usr/bin/env bash

start() {
	nohup "$@" &> /dev/null &
}

WALLPAPER_PATH="$(find "$HOME"/Wallpapers/ -type f | shuf -n1)"
POLKIT="/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"

pgrep -x swww		|| start swww-daemon && swww img "$WALLPAPER_PATH" --transition-type none

pgrep -x gammastep	|| start gammastep -P -O 5000
pgrep -x blueman	|| start blueman-applet
pgrep -x thunar		|| start thunar --daemon
pgrep -x gnome		|| start "$POLKIT"
pgrep -x dunst		|| start dunst
pgrep -x server		|| start swayosd-server
pgrep -x easy		|| start easyeffects --gapplication-service
pgrep -x swayidle	|| start swayidle -w timeout 600 "bash -c '$HOME/.config/hypr/scripts/lock-session.sh'"

start dex -a
start wl-paste --type text --watch cliphist store
start wl-paste --type image --watch cliphist store

# gsettings set org.gnome.desktop.interface gtk-theme		'gruvbox'
# gsettings set org.gnome.desktop.interface cursor-theme	'material_light_cursors'
# gsettings set org.gnome.desktop.interface icon-theme	'Papirus-Dark'

