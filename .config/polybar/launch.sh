#!/usr/bin/env bash

polybar single --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_single.log &

# monitor_poll=$(xrandr|grep "DP-3-1"|grep " disconnected")

# RIGHT_MONITOR=DP-2-3
# LEFT_MONITOR=DP-2-2
# ONBOARD_MONITOR=eDP-1

# monitor_poll=$(xrandr -q|grep -Po "[A-Za-z0-9-]+ connected")
# 
# left_exists=$(echo $monitor_poll|grep "${LEFT_MONITOR}")
# right_exists=$(echo $monitor_poll|grep "${RIGHT_MONITOR}")
# 
# [ -n "${left_exists}" ] && export LEFT_MONITOR=$LEFT_MONITOR && polybar double-left --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_left.log &
# 
# [ -n "${right_exists}" ] && export RIGHT_MONITOR=$RIGHT_MONITOR && polybar double-right --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_right.log &
# 
# [ -z "${left_exists}" ] && [ -z "${right_exists}" ] && polybar single --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_single.log &


# echo "[RELOAD] ---" | tee -a /tmp/polybar1.log /tmp/polybar2.log

# if [[ $monitor_poll == "" ]]; then
#     export PRIMARY_MONITOR=DP-3-1
# else
#     export PRIMARY_MONITOR=eDP-1
# fi
# echo $PRIMARY_MONITOR

#if [[ $monitor_poll == "" ]]; then
#	export LEFT_MONITOR=DP-3
#	export RIGHT_MONITOR=eDP-1
#
#	polybar double-left --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_left.log &
#	polybar double-right --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_right.log &
#else
#	polybar single --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_single.log &
#fi

# polybar single --reload --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_single.log &


