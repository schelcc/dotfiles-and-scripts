#!/bin/bash

LAPTOP=eDP-1
EXTERNAL=DP-3-1

echo "pause for monitor initialization"
sleep 5s

dock_check=$(xrandr -q|grep " connected"|grep $EXTERNAL)
work_home_check=$(lsusb | grep "Lenovo USB3.1 Hub")

if [[ $dock_check == "" ]]; then
	xrandr --output $LAPTOP --mode 1920x1200 --auto
	MONITOR=$LAPTOP
else
	if [[ $work_home_check == "" ]]; then
		xrandr --output $LAPTOP --off --output $EXTERNAL --mode 3440x1440 --auto
	else
		xrandr --output $LAPTOP --left-of $EXTERNAL --output $EXTERNAL --mode 3840x2160 --auto
	fi
	MONITOR=$EXTERNAL
fi

background-manager &
polybar-msg cmd restart

echo $MONITOR
