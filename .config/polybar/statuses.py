#!/usr/bin/env python3

from sys import argv
from os import environ

HOME = environ['HOME']

def check_status(key):
	output = None

	with open(f"{HOME}/.config/polybar/statuses.txt", "r") as f:
		for line in f.read().splitlines():
			if key in line:
				output = line.split("=")[-1]
	return output

def toggle_status(key):
	with open(f"{HOME}/.config/polybar/statuses.txt", "r") as f:
		full_text = f.read()
	
	lines_arr = full_text.splitlines()

	for idx, line in enumerate(lines_arr):
		if key in line:
			cur_value = bool(int(line.split("=")[-1]))
			new_value = int((not cur_value))
			new_line = line.split("=")[0] + "=" + str(new_value)
			lines_arr[idx] = new_line
	
	new_file = '\n'.join(lines_arr)

	with open(f"{HOME}/.config/polybar/statuses.txt", "w") as f:
		f.write(new_file)

if __name__ == "__main__":
	if argv[1] == "check_status":
		print(check_status(argv[2]))
	elif argv[1] == "toggle_status":
		toggle_status(argv[2])
