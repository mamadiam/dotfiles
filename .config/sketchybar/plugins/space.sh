#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

# Called on every aerospace_change for each space item ($NAME = "space.N").
# NOTE: sketchybar v2's CLI --trigger does not forward KEY=VALUE env vars, so
# instead of trusting $AEROSPACE_FOCUSED_WORKSPACE we ask AeroSpace directly.

N="${NAME#space.}"

# the hook can fire mid-switch — let AeroSpace settle, then ask
sleep 0.5

if [ "$FOCUSED" = "$N" ]; then
	sketchybar --animate tanh 5 --set "$NAME" \
		icon.color="$RED" \
		icon="$N"
else
	sketchybar --animate tanh 5 --set "$NAME" \
		icon.color="$COMMENT" \
		icon="$N"
fi
