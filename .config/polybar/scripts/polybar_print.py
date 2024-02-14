import configparser
import os
from string import punctuation

polybar_config = configparser.ConfigParser()
polybar_config.read(f"{os.environ['HOME']}/.config/polybar/colors.ini")


fg = polybar_config['util-colors']['foreground']
ul = polybar_config['util-colors']['accent']

def polybar_print(msg, fg_key='foreground', ul_key=None):
	fg_color = polybar_config['util-colors'][fg_key]

	output = ""
	
	if ul_key is not None:
		ul_color = polybar_config['util-colors'][ul_key]
		underline_str = "%{u" + ul_color + "}%{+u}"
		output += underline_str

	foreground_str = "%{F" + fg_color + "}" + msg + "%{F-}"
	
	output += foreground_str

	return(output)
