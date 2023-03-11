#!/usr/bin/env python3

import os
import subprocess
import sys

status = str(subprocess.check_output("playerctl status", shell=True))[2:-3]

if status == "Playing":
    output = ""
elif status == "Paused":
    output = ""
elif status == "Stopped":
    output = ""
    
if sys.argv[1] == "1":
    subprocess.check_output("playerctl play-pause", shell=True)
    
print(output)