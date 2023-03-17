#!/bin/bash

# Init any newly connected monitors
xrandr --auto

# Set monitors with presets
xrandr --output eDP-1 --primary --mode 1920x1200 --pos 2400x0 --rotate normal --output HDMI-1 --off --output DP-1 --off --output HDMI-2 --off --output DP-2 --mode 1920x1080 --pos 0x0 --rotate normal --scale 1.25x1.25 --output HDMI-3 --off --output DP-3 --off --output DP-4 --off

# Swap caps and LCtrl - Do this because when ws_dock is run there is also a new keyboard attached
setxkbmap -layout us -option ctrl:swapcaps

i3-msg restart

$HOME/.config/polybar/launch.sh &

wallpaper.sh &
