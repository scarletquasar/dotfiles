#!/bin/bash

killall -q waybar
while pgrep -u $UID -x waybar >/dev/null; do sleep 0.1; done
nohup waybar &> /dev/null &


config_file="$HOME/.config/waybar/config"
style_file="$HOME/.config/waybar/style.css"

old_config_hash=""
old_style_hash=""

while true; do
    new_config_hash=$(md5sum "$config_file" | awk '{print $1}')
    new_style_hash=$(md5sum "$style_file" | awk '{print $1}')
    
    if [ "$new_config_hash" != "$old_config_hash" ] || [ "$new_style_hash" != "$old_style_hash" ]; then
        pkill -x waybar
        nohup waybar &> /dev/null &
        
        old_config_hash="$new_config_hash"
        old_style_hash="$new_style_hash"
    fi
    sleep 1
done
