#!/usr/bin/env python3

import json
import os
from configparser import ConfigParser, ExtendedInterpolation

'''
x- Polybar
- dunst
x- i3 borders
- rofi
- vscode
'''

HOME = os.environ['HOME']

# Determine previous color state
# 0/False - Dark, 1/True - light
with open(HOME + "/bin/color_state.txt", "r") as f:
	color_state = bool(int(f.read()))

color_suffix = "light" if color_state else "dark"
opp_color_suffix = "dark" if color_state else "light"

# Flip and write color state
with open(HOME + "/bin/color_state.txt", "w") as f:
	f.write(str(int(not color_state)))

# i3 settings
# Current i3 colors
theme = ConfigParser(interpolation=ExtendedInterpolation())
theme.read(HOME + f'/.config/i3/gruvbox-{color_suffix}.ini')
colors = theme['util-colors']

i3_theme = f"""
# class                 border  backgr. text    indicator
client.focused          {colors['background']} {colors['alt-background']}  {colors['accent']}     {colors['accent']}
client.focused_inactive {colors['background']} {colors['alt2-background']} {colors['foreground']} {colors['alt2-background']}
client.unfocused        {colors['background']} {colors['alt2-background']} {colors['foreground']} {colors['alt2-background']}
client.urgent           {colors['alert']}      {colors['accent']}          {colors['background']} {colors['accent']}
"""

with open(HOME + "/.config/i3/config.base", "r") as f:
	cur_config = f.read()

cur_config = cur_config.replace("## THEME ##", i3_theme)

with open(HOME + "/.config/i3/config", "w") as f:
	f.write(cur_config)

# polybar
os.system(f"cp {HOME}/.config/polybar/gruvbox-{color_suffix}.ini {HOME}/.config/polybar/colors.ini")

# .Xdefaults
os.system(f"cp {HOME}/.Xdefaults-{color_suffix} .Xdefaults")

# dunst
os.system(f"cp {HOME}/.config/dunst/dunstrc-{color_suffix} {HOME}/.config/dunst/dunstrc")

# ROFI
with open(HOME + "/.config/rofi/config.rasi", "r") as f:
	cur_config = f.read()

cur_config = cur_config.replace(f"gruvbox-{opp_color_suffix}.rasi", f"gruvbox-{color_suffix}.rasi")

with open(HOME + "/.config/rofi/config.rasi", "w") as f:
	f.write(cur_config)

# VSCode
with open(HOME + "/.config/Code/User/settings.json", "r") as f:
	code_conf = json.load(f)

code_conf['workbench.colorTheme'] = \
	code_conf[f'workbench.preferred{color_suffix.title()}ColorTheme']

with open(HOME + "/.config/Code/User/settings.json", "w") as f:
	json.dump(code_conf, f)

# alacritty
os.system(f"cp {HOME}/.config/alacritty/alacritty-{color_suffix}.yml {HOME}/.config/alacritty/alacritty.yml") 

os.system('i3-msg restart')
os.system('killall dunst')
os.system('/usr/bin/dunst')
os.system(f"notify-send \"Theme switched to {color_suffix} mode\"")
