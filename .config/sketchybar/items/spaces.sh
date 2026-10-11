#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

# AeroSpace drives VIRTUAL workspaces (not native macOS spaces), so these are
# plain items highlighted via the aerospace_change event — see plugins/space.sh.

sketchybar --add item spacer.1 left \
	--set spacer.1 width=6 \
	background.drawing=off \
	label.drawing=off \
	icon.drawing=off

for sid in {1..8}; do
	sketchybar --add item space.$sid left \
		--set space.$sid \
		icon="$sid" \
		icon.padding_left=9 \
		icon.padding_right=9 \
		label.drawing=off \
		icon.color="$COMMENT" \
		click_script="aerospace workspace $sid" \
		script="$PLUGIN_DIR/space.sh" \
		--subscribe space.$sid aerospace_change
done

sketchybar --add item spacer.2 left \
	--set spacer.2 width=5 \
	background.drawing=off \
	label.drawing=off \
	icon.drawing=off
