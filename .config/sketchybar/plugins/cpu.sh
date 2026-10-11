#!/usr/bin/env bash

# hide the info popup when the pointer leaves the bar
if [ "$SENDER" = "mouse.exited.global" ]; then
	sketchybar --set "$NAME" popup.drawing=off
	exit 0
fi

sketchybar --set "$NAME" icon="" label="$(ps -A -o %cpu | awk '{s+=$1} END {s /= 8} END {printf "%.1f%%\n", s}')"
