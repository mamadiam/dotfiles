#!/usr/bin/env bash

COLOR="$YELLOW"

sketchybar --add item cpu right \
	--set cpu \
	update_freq=3 \
	icon.color="$COLOR" \
	icon.padding_left=10 \
	label.color="$COLOR" \
	label.padding_right=10 \
	background.height=26 \
	background.corner_radius="$CORNER_RADIUS" \
	background.padding_right=5 \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$COLOR" \
	background.color="$BAR_COLOR" \
	background.drawing=on \
	script="$PLUGIN_DIR/cpu.sh" \
		click_script="open -a "Activity Monitor"" \
		click_script="open -a 'Activity Monitor'"

# info popup (rows filled by plugins/popup.sh, toggled on click)
for i in 1 2 3; do
	sketchybar --add item "cpu.p$i" popup.cpu \
		--set "cpu.p$i" background.drawing=off \
		icon.drawing=off \
		label="" \
		label.color="$LABEL_COLOR" \
		label.padding_left=12 \
		label.padding_right=12 \
		label.align=left \
		width=230
done

# close the popup when the pointer leaves
sketchybar --subscribe cpu mouse.exited.global
