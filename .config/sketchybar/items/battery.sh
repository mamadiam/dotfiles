#!/usr/bin/env bash

COLOR="$CYAN"

sketchybar --add item battery right \
	--set battery \
	update_freq=60 \
	icon.color="$COLOR" \
	icon.padding_left=10 \
	label.padding_right=10 \
	label.color="$COLOR" \
	background.height=26 \
	background.corner_radius="$CORNER_RADIUS" \
	background.padding_right=5 \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$COLOR" \
	background.color="$BAR_COLOR" \
	background.drawing=on \
	script="$PLUGIN_DIR/power.sh" \
	--subscribe battery power_source_change \ \
		click_script="open "x-apple.systempreferences:com.apple.preference.battery""
		click_script='open "x-apple.systempreferences:com.apple.preference.battery"'

# info popup (rows filled by plugins/popup.sh, toggled on click)
for i in 1 2 3; do
	sketchybar --add item "battery.p$i" popup.battery \
		--set "battery.p$i" background.drawing=off \
		icon.drawing=off \
		label="" \
		label.color="$LABEL_COLOR" \
		label.padding_left=12 \
		label.padding_right=12 \
		label.align=left \
		width=230
done

# close the popup when the pointer leaves
sketchybar --subscribe battery mouse.exited.global
