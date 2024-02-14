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

def read_sys_file(path):
    with open(path, "r") as f:
        return(f.read().strip())

moderate_threshold = 20
severe_threshold = 10
immediate_threshold = 5

max_capacity_pct = 100

capacity_symbols = ["","","","",""]

is_charging = bool(int(read_sys_file("/sys/class/power_supply/AC/online")))
energy_now = int(read_sys_file("/sys/class/power_supply/BAT0/energy_now"))
energy_full = int(read_sys_file("/sys/class/power_supply/BAT0/energy_full"))
power_now = int(read_sys_file("/sys/class/power_supply/BAT0/power_now"))

charge_pct = (energy_now / energy_full) * 100
charge_pct = round(charge_pct)

adj_charge_pct = (charge_pct / max_capacity_pct) * 100
adj_charge_pct = round(adj_charge_pct)
symbol_index = (adj_charge_pct+5) // 25

try:
	time_remaining_min = (energy_now / power_now) * 60
except ZeroDivisionError:
	time_remaining_min = 0

H, M = divmod(time_remaining_min, 60)
H, M = int(H), int(M)
time_remaining_str = f"{H:>2}:{str(M).zfill(2)}"

underline_color = 'accent'

if is_charging:
	underline_color = 'accent'
	symbol_index = trunc(time() % 5)

if is_charging and adj_charge_pct >= 99:
	underline_color = 'success'
	symbol_index = len(capacity_symbols)-1

if not is_charging and adj_charge_pct <= 15:
	underline_color = 'alert'
	symbol_index = floor((time() % 3)/1.5)*(len(capacity_symbols)-1)
	

charge_pct_output = f"{capacity_symbols[symbol_index]} {adj_charge_pct:>2}%"
charge_time_remaining_output = f"{capacity_symbols[symbol_index]}{time_remaining_str}"

toggle = check_status("battery")

if toggle == "0":
	print(polybar_print(charge_pct_output, ul_key=underline_color))
elif toggle == "1":
	print(polybar_print(charge_time_remaining_output, ul_key=underline_color))

