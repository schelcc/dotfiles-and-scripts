#!/usr/bin/env python3
import subprocess

moderate_threshold = 20
severe_threshold = 10
immediate_threshold = 5

charging_status_sel = [False, True]
is_charging_cmd = "cat /sys/class/power_supply/AC/online"
is_charging_str = str(subprocess.check_output(is_charging_cmd, shell=True))[2:-3]
is_charging = charging_status_sel[int(is_charging_str)]

status_cmd = "cat /sys/class/power_supply/BAT0/uevent | grep _ENERGY"

status_stdout = str(subprocess.check_output(status_cmd, shell=True))[2:-3]

statuses = status_stdout.split('\\n')

numbers = []

for status in statuses:
	for idx, ch in enumerate(status):
		if ch.isnumeric():
			numbers.append(int(status[idx:-1]))
			break

full_design, full, now = numbers

charge_pct = (now / full_design) * 100

result_cmd = "/home/schelcc/bin/battery_scripts.sh "

if is_charging:
	result_cmd +="-1"
elif charge_pct <= immediate_threshold:
	result_cmd +="3"
elif charge_pct <= severe_threshold:
	result_cmd +="2"
elif charge_pct <= moderate_threshold:
	result_cmd +="1"
else:
	print("Nothing to do")
	exit

print(result_cmd)
subprocess.check_output(result_cmd, shell=True)
