#!/bin/sh

pgrep -x alacritty > /dev/null 2>&1 && {
	nohup alacritty msg create-window > /dev/null
	exit
}

alacritty
