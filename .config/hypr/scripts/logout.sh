#!/usr/bin/env bash

stop() {
	kill -s 9 "$1"
}

killall bash && killall /bin/bash
pgrep -x Discord && stop Discord
pgrep -x spotify && stop spotify
hyprctl dispatch exit
