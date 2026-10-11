#!/usr/bin/env bash

COLOR="$MAGENTA"

sketchybar --add item clock right \
	--set clock update_freq=1 \
	icon.padding_left=10 \
	icon.color="$COLOR" \
	icon="" \
	label.color="$COLOR" \
	label.padding_right=5 \
	label.width=78 \
	align=center \
	background.height=26 \
	background.corner_radius="$CORNER_RADIUS" \
	background.padding_right=2 \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$COLOR" \
	background.color="$BAR_COLOR" \
	background.drawing=on \
	script="$PLUGIN_DIR/clock.sh" \
		click_script="open "x-apple.systempreferences:com.apple.preference.datetime"" \
		click_script='open "x-apple.systempreferences:com.apple.preference.datetime"'

# info popup (rows filled by plugins/popup.sh, toggled on click)
for i in 1 2 3; do
	sketchybar --add item "clock.p$i" popup.clock \
		--set "clock.p$i" background.drawing=off \
		icon.drawing=off \
		label="" \
		label.color="$LABEL_COLOR" \
		label.padding_left=12 \
		label.padding_right=12 \
		label.align=left \
		width=230
done

# close the popup when the pointer leaves
sketchybar --subscribe clock mouse.exited.global
