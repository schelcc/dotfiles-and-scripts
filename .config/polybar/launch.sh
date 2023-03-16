#!/usr/bin/env bash

killall -q polybar


echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar single --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar1.log
