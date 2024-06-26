#!/usr/bin/env bash

monitor_poll=$(xrandr|grep "DP-3-1"|grep " disconnected")

echo "[RELOAD] ---" | tee -a /tmp/polybar1.log /tmp/polybar2.log

if [[ $monitor_poll == "" ]]; then
    export PRIMARY_MONITOR=DP-3-1
else
    export PRIMARY_MONITOR=eDP-1
fi
echo $PRIMARY_MONITOR

#if [[ $monitor_poll == "" ]]; then
#	export LEFT_MONITOR=DP-3
#	export RIGHT_MONITOR=eDP-1
#
#	polybar double-left --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_left.log &
#	polybar double-right --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_right.log &
#else
#	polybar single --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_single.log &
#fi

polybar single --reload --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_single.log &


