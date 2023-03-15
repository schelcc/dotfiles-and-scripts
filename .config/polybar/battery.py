#!/usr/bin/env python3

from subprocess import check_output
import datetime
from sys import argv
from time import time
from math import trunc, floor
from polybar_print import polybar_print
from configparser import ConfigParser
from os import environ
from statuses import *

HOME = environ['HOME']

polybar_config = ConfigParser()
polybar_config.read(f"{HOME}/.config/polybar/gruvbox.ini")

foreground_color = polybar_config['colors']['light-text']
underline_color = polybar_config['colors']['active-underline']
alert_color = polybar_config['colors']['alert']
full_color = polybar_config['colors']['success']

moderate_threshold = 20
severe_threshold = 10
immediate_threshold = 5

max_capacity_pct = 100

capacity_symbols = ["","","","",""]

cmd = "cat /sys/class/power_supply/AC/online"
is_charging_str = str(check_output(cmd, shell=True))[2:-3]
is_charging = bool(int(is_charging_str))

cmd = "cat /sys/class/power_supply/BAT0/energy_now"
energy_now_str = str(check_output(cmd, shell=True))[2:-3]
energy_now = int(energy_now_str)

cmd = "cat /sys/class/power_supply/BAT0/energy_full"
energy_full_str = str(check_output(cmd, shell=True))[2:-3]
energy_full = int(energy_full_str)

cmd = "cat /sys/class/power_supply/BAT0/power_now"
power_now_str = str(check_output(cmd, shell=True))[2:-3]
power_now = int(power_now_str)

charge_pct = (energy_now / energy_full) * 100
charge_pct = round(charge_pct)

adj_charge_pct = (charge_pct / max_capacity_pct) * 100
adj_charge_pct = round(adj_charge_pct)
symbol_index = (adj_charge_pct+5) // 25

time_remaining_min = (energy_now / power_now) * 60
H, M = divmod(time_remaining_min, 60)
H, M = int(H), int(M)
time_remaining_str = f"{H:>2}:{str(M).zfill(2)}"

if is_charging:
	symbol_index = trunc(time() % 5)

if is_charging and adj_charge_pct >= 99:
	underline_color = full_color

if not is_charging and adj_charge_pct <= 15:
	underline_color = alert_color
	symbol_index = floor((time() % 3)/1.5)*(len(capacity_symbols)-1)
	

charge_pct_output = f"{capacity_symbols[symbol_index]} {adj_charge_pct:>2}%"
charge_time_remaining_output = f"{capacity_symbols[symbol_index]}{time_remaining_str}"

toggle = check_status("battery")

if toggle == "0":
	print(polybar_print(charge_pct_output, foreground_color=foreground_color, underline_color=underline_color))
elif toggle == "1":
	print(polybar_print(charge_time_remaining_output, foreground_color=foreground_color, underline_color=underline_color))

