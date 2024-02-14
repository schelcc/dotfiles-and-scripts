#!/bin/bash
scrot -s -F '/home/schelcc/Pictures/screenshots/%Y-%m-%d_%H:%M.png' -z -e 'xclip -selection clipboard -target image/png -i $f'
