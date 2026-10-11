#!/usr/bin/env bash

# hide the info popup when the pointer leaves the bar
if [ "$SENDER" = "mouse.exited.global" ]; then
	sketchybar --set "$NAME" popup.drawing=off
	exit 0
fi

sketchybar --set "$NAME" icon="󰸗" label="$(date '+%a %d. %b')"
