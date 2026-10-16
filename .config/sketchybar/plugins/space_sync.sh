#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

# Single consumer of aerospace_change: mirrors AeroSpace's workspace set into
# the bar (GlazeWM-style — empty workspaces vanish, focused is highlighted in
# the front-app color: white on a mini pill).

# the hook can fire mid-switch — let AeroSpace settle, then ask once
sleep 0.5

FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
EXISTING=$(aerospace list-workspaces --all 2>/dev/null | tr '\n' ' ')

for sid in {1..8}; do
	if grep -qw "$sid" <<< "$EXISTING"; then
		# flip drawing first — animating a color on a not-yet-drawn item races
		# and ends up unset (0x0)
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
			sketchybar --animate tanh 8 --set "space.$sid" icon.color="$WHITE"
		else
			sketchybar --set "space.$sid" drawing=on background.drawing=off
			sketchybar --animate tanh 8 --set "space.$sid" icon.color="$GREY"
		fi
	else
		sketchybar --set "space.$sid" drawing=off
	fi
done
