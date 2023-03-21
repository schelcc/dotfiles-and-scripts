#!/bin/bash

# Init any newly connected monitors
xrandr --auto

LAPTOP=eDP-1
EXTERNAL=DP-3

dock_check=$(xrandr --listactivemonitors|grep $EXTERNAL)

if [[ $dock_check == "" ]]; then
	xrandr --output $LAPTOP --mode 1920x1200 --scale 1.0x1.0
else
	xrandr --output $LAPTOP --primary --mode 1920x1200 --pos 2400x0 --rotate normal --scale 0.85x0.85 \
		--output $EXTERNAL --mode 1920x1080 --pos 0x0 --rotate normal --scale 1.25x1.25
fi

# Swap caps and LCtrl - Do this because when ws_dock is run there is also a new keyboard attached
setxkbmap -layout us -option ctrl:swapcaps

i3-msg restart

$HOME/.config/polybar/launch.sh &

wallpaper.sh &
