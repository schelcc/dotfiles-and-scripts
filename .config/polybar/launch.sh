#!/usr/bin/env bash

killall -q polybar
killall xcompmgr

xcompmgr -c -C &

echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar gruvbox --config=$HOME/.config/polybar/gruvbox.ini 2>&1 | tee -a /tmp/polybar1.log

# echo "---" | tee -a /tmp/polybar3.log /tmp/polybar4.log
# polybar gruvbox-top --config=$HOME/.config/polybar/gruvbox.ini 2>&1 | tee -a /tmp/polybar1.log
