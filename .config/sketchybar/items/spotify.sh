#!/usr/bin/env bash

COLOR="$GREEN"

sketchybar --add item spotify q \
	--set spotify \
	scroll_texts=on \
	icon=󰎆 \
	icon.color="$COLOR" \
	icon.padding_left=10 \
	background.color="$BAR_COLOR" \
	background.height=26 \
	background.corner_radius="$CORNER_RADIUS" \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$COLOR" \
	background.padding_right=-5 \
	background.drawing=on \
	label.padding_right=10 \
	label.max_chars=23 \
	associated_display=active \
	updates=on \
	script="$PLUGIN_DIR/spotify.sh" \
	--subscribe spotify spotify_media \ \
		click_script="osascript -e 'tell application \"Spotify\" to playpause'"

# info popup (rows filled by plugins/popup.sh, toggled on click)
for i in 1 2 3; do
	sketchybar --add item "spotify.p$i" popup.spotify \
		--set "spotify.p$i" background.drawing=off \
		icon.drawing=off \
		label="" \
		label.color="$LABEL_COLOR" \
		label.padding_left=12 \
		label.padding_right=12 \
		label.align=left \
		width=230
done

# close the popup when the pointer leaves
sketchybar --subscribe spotify mouse.exited.global
