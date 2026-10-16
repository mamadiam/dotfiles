#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

# DYNAMIC AeroSpace workspaces (GlazeWM-style): empty workspaces vanish, so
# items are pre-created HIDDEN here (stable left-to-right order) and one
# hidden sync item consumes aerospace_change to show/hide/highlight them —
# see plugins/space_sync.sh. Alt-1..8 recreate a vanished workspace on jump.

sketchybar --add item spacer.1 left \
	--set spacer.1 width=6 \
	background.drawing=off \
	label.drawing=off \
	icon.drawing=off

for sid in {1..8}; do
	sketchybar --add item "space.$sid" left \
		--set "space.$sid" \
		icon="$sid" \
		icon.padding_left=7 \
		icon.padding_right=7 \
		label.drawing=off \
		icon.color="$GREY" \
		drawing=off \
		click_script="aerospace workspace $sid"
done

sketchybar --add item space.sync left \
	--set space.sync width=0 \
	background.drawing=off \
	label.drawing=off \
	icon.drawing=off \
	script="$PLUGIN_DIR/space_sync.sh" \
	--subscribe space.sync aerospace_change

sketchybar --add item spacer.2 left \
	--set spacer.2 width=5 \
	background.drawing=off \
	label.drawing=off \
	icon.drawing=off
