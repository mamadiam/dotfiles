#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

# Single consumer of aerospace_change: mirrors AeroSpace's workspaces into the
# bar with STICKY slots (Zebar-style): once a workspace is revealed it sits in
# the bar for the whole session — dimmed when empty — and the focused one
# wears the front-app color (white mini-pill). The revealed set resets on bar
# restart / reboot.

# the hook can fire mid-switch — let AeroSpace settle, then ask once
sleep 0.5

CACHE_DIR="$HOME/.cache/sketchybar"
REVEALED_FILE="$CACHE_DIR/revealed_spaces"
mkdir -p "$CACHE_DIR"
touch "$REVEALED_FILE"

FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
EXISTING=$(aerospace list-workspaces --all 2>/dev/null | tr '\n' ' ')

# reveal = occupied/focused now OR already revealed (never un-reveal)
for sid in $EXISTING; do
	grep -qx "$sid" "$REVEALED_FILE" || echo "$sid" >> "$REVEALED_FILE"
done

for sid in {1..8}; do
	if ! grep -qx "$sid" "$REVEALED_FILE"; then
		sketchybar --set "space.$sid" drawing=off
		continue
	fi

	if [ "$sid" = "$FOCUSED" ]; then
		sketchybar --set "space.$sid" drawing=on \
			background.drawing=on \
			background.color="$BAR_COLOR" \
			background.border_color="$WHITE" \
			background.border_width="$BORDER_WIDTH" \
			background.corner_radius="$CORNER_RADIUS" \
			background.height=26 \
			background.padding_left=4 \
			background.padding_right=4
		sketchybar --set "space.$sid" icon.color="$WHITE"
	elif grep -qw "$sid" <<< "$EXISTING"; then
		# occupied, unfocused
		sketchybar --set "space.$sid" drawing=on background.drawing=off icon.color="$GREY"
	else
		# revealed but empty — parked, faint
		sketchybar --set "space.$sid" drawing=on background.drawing=off
		sketchybar --set "space.$sid" icon.color="$COMMENT"
	fi
done
