#!/bin/bash

# Init any newly connected monitors
xrandr --auto

LAPTOP=eDP-1
EXTERNAL=DP-3-1

dock_check=$(xrandr --listactivemonitors|grep $EXTERNAL)

if [[ $dock_check == "" ]]; then
	xrandr --output $LAPTOP --mode 1920x1200 --scale 1.0x1.0
else
	xrandr --output $LAPTOP --off --output $EXTERNAL --mode 3440x1440
fi

background-manager &

$HOME/.config/polybar/launch.sh
