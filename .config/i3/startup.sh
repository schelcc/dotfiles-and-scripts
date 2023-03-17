#!/bin/bash
setxkbmap -layout us -option ctrl:swapcaps & 
compositor-startup.sh
devilspie &
xpad &
blueman-applet &
wallpaper.sh &
xscreensaver &
spotify &
discord &
gnome-calculator &

