def polybar_print(msg, foreground_color=None, underline_color=None):
	output = ""
	
	if underline_color is not None:
		underline_str = "%{u" + underline_color + "}%{+u}"
		output += underline_str

	if foreground_color is not None:
		foreground_str = "%{F" + foreground_color + "}" + msg + "%{F-}"
	else:
		foreground_str = msg
	
	output += foreground_str

	return(output)
