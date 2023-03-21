#!/bin/bash
severity=$1

MONITOR="eDP-1"

if [[ $severity -eq 1 ]]
then
	# Moderate battery events ( Below 20% )
	notify-send "Battery Saver" "20% Battery remaining"
	xrandr --output $MONITOR --brightness 0.7
elif [[ $severity -eq 2 ]]
then
	# Severe battery events ( Below 10% )
	notify-send "Battery Saver" "10% Battery remaining" -u critical
	xrandr --output $MONITOR --brightness 0.5
elif [[ $severity -eq 3 ]]
then
	# Immediate battery events ( Below 5% )
	notify-send "Battery Saver" "5% Battery remaining - Plug in now."
	xrandr --output $MONITOR --brightness 0.3
elif [[ $severity -eq -1 ]]
then
	# Actively charging	
fi

