#!/usr/bin/env bash

ANIMATIONS_IS_ENABLED="$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')"
WALLPAPER_PATH="$(find $HOME/trash/Wallpapers/Gruvbox/ -type f | shuf -n1)"

if [ "$ANIMATIONS_IS_ENABLED" = 1 ]; then 
	swww img "$WALLPAPER_PATH" --transition-fps 144 --transition-type wipe  --transition-duration 3 --transition-angle 45 --transition-step 10 --transition-bezier 0.76,0,0.24,1
else
	swww img "$WALLPAPER_PATH" --transition-type none
fi
