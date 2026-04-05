#!/bin/bash
GHOSTTY_CONFIG=$HOME/.config/ghostty/config.ghostty
GHOSTTY_LIGHT='Gruvbox Light'
GHOSTTY_DARK='Gruvbox Dark'
EMACS_LIGHT='gruvbox-light-soft'
EMACS_DARK='gruvbox-dark-soft'

# Check that the dark theme is there, if it's not toggle to it, else to light
IS_GHOSTTY_DARK=$(grep "${GHOSTTY_DARK}" $GHOSTTY_CONFIG)
if [ -z "$IS_GHOSTTY_DARK" ];
then
	sed -i "s/${GHOSTTY_LIGHT}/${GHOSTTY_DARK}/" $GHOSTTY_CONFIG
	emacsclient -e "(load-theme '${EMACS_DARK})"
	notify-send --icon=$HOME/icons/ghostty.png --urgency=low --expire-time=1000 "Toggled from light to dark"
else
	sed -i "s/${GHOSTTY_DARK}/${GHOSTTY_LIGHT}/" $GHOSTTY_CONFIG
	emacsclient -e "(load-theme '${EMACS_LIGHT})"
	notify-send --icon=$HOME/icons/ghostty.png --urgency=low --expire-time=1000 "Toggled from dark to light"
fi

# Force all ghostty sessions to reload
# See: https://github.com/ghostty-org/ghostty/discussions/3643
kill -s USR2 $(pgrep ghostty)
