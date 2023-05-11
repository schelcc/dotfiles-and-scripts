import configparser
import os
from string import punctuation

polybar_config = configparser.ConfigParser()
polybar_config.read(f"{os.environ['HOME']}/.config/polybar/colors.ini")

def key_resolver(util_key):
	root, color = polybar_config['util-colors'][util_key].strip(punctuation).split('.')
	return polybar_config[root][color]

fg = key_resolver('foreground')
ul = key_resolver('accent')

def polybar_print(msg, fg_key='foreground', ul_key=None):
	fg_color = key_resolver(fg_key)

	output = ""
	
	if ul_key is not None:
		ul_color = key_resolver(ul_key)
		underline_str = "%{u" + ul_color + "}%{+u}"
		output += underline_str

	foreground_str = "%{F" + fg_color + "}" + msg + "%{F-}"
	
	output += foreground_str

	return(output)
