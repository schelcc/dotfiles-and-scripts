#!/bin/bash

context=$1
arg=$2

status=$(playerctl status 2> /dev/null)

if [[ $1 == "player" ]]; then
	if [[ $2 == "prev" ]]; then
		if [[ $3 == "1" ]]; then
			playerctl previous
		fi
		echo "󰒮"

	elif [[ $2 == "next" ]]; then
		if [[ $3 == "1" ]]; then
			playerctl next
		fi
		echo "󰒭"

	elif [[ $2 == "playpause" ]]; then
		if [[ $3 == "1" ]]; then
			playerctl play-pause
		fi
		
		if [[ $status == "Playing" ]]; then
			output=""
		elif [[ $status == "Paused" ]]; then
			output=""
		elif [[ $status == "Stopped" ]]; then
			output=""
		fi

		echo $output
	fi
fi

if [[ $1 == "info" ]]; then
	cat $HOME/.config/polybar/music-output
fi



