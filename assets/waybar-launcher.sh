#!/bin/sh
# sunshinedots-waybar-launcher
# Sunshine Hyprland Dots keep the Waybar config in ~/.config/hypr/waybar, which
# a bare `waybar` (rofi's run mode, a terminal) never looks at: it falls back to
# the stock bar and starts a second one. With no arguments, hand off to
# WaybarStartup.sh, which loads the dots' config and keeps a single bar.
# With arguments, run the real binary untouched.
startup="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/scripts/WaybarStartup.sh"
if [ "$#" -eq 0 ] && [ -x "$startup" ]; then
  exec "$startup" --restart
fi
exec /usr/bin/waybar "$@"
