#!/usr/bin/env bash

killall -q polybar

echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar gruvbox --config=$HOME/.config/polybar/gruvbox.ini 2>&1 | tee -a /tmp/polybar1.log
