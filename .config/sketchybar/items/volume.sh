#!/usr/bin/env bash

COLOR="$GREEN"

sketchybar \
	--add item sound right \
	--set sound \
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
	script="$PLUGIN_DIR/sound.sh" \
	--subscribe sound volume_change \ \
		click_script="open "x-apple.systempreferences:com.apple.preference.sound""
		click_script='open "x-apple.systempreferences:com.apple.preference.sound"'

# info popup (rows filled by plugins/popup.sh, toggled on click)
for i in 1 2 3; do
	sketchybar --add item "sound.p$i" popup.sound \
		--set "sound.p$i" background.drawing=off \
		icon.drawing=off \
		label="" \
		label.color="$LABEL_COLOR" \
		label.padding_left=12 \
		label.padding_right=12 \
		label.align=left \
		width=230
done

# close the popup when the pointer leaves
sketchybar --subscribe sound mouse.exited.global
