#!/usr/bin/env bash

# hide the info popup when the pointer leaves the bar
if [ "$SENDER" = "mouse.exited.global" ]; then
	sketchybar --set "$NAME" popup.drawing=off
	exit 0
fi

# Adapted from tcmmichaelb139's spotify plugin: his version parses the native
# media_change INFO JSON, which never fires on macOS 27 (MediaRemote gated).
# It consumes the custom `spotify_media` event from plugins/media_event
# (Spotify AppleScript poller) instead, via plain env vars.
#
# Pill stays visible while Spotify is running (dimmed when paused); it only
# hides when Spotify isn't running at all.

if [ "$STATE" = "playing" ]; then
	sketchybar --set "$NAME" \
		icon.color="$GREEN" \
		background.border_color="$GREEN" \
		label="$TITLE - $ARTIST" \
		label.color="$WHITE" \
		drawing=on
elif [ "$STATE" = "paused" ]; then
	sketchybar --set "$NAME" \
		icon.color="$GREY" \
		background.border_color="$GREY" \
		label="$TITLE - $ARTIST" \
		label.color="$COMMENT" \
		drawing=on
else
	# Spotify not running — dim pill, no label
	sketchybar --set "$NAME" \
		icon.color="$COMMENT" \
		background.border_color="$COMMENT" \
		label="" \
		drawing=on
fi
