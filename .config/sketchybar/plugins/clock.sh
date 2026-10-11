#!/usr/bin/env bash

# hide the info popup when the pointer leaves the bar
if [ "$SENDER" = "mouse.exited.global" ]; then
	sketchybar --set "$NAME" popup.drawing=off
	exit 0
fi

LABEL=$(date '+%H:%M:%S')
sketchybar --set "$NAME" label="$LABEL"
