#!/usr/bin/env bash
# popup.sh <widget> — toggles an info popup under a bar widget and fills it.
# Popup rows are created by the widget's items/*.sh file (named <widget>.p1..p4).

source "$HOME/.config/sketchybar/variables.sh"

WIDGET="$1"

fill() {
	case "$WIDGET" in
	calendar)
		sketchybar \
			--set "$WIDGET.p1" label="$(date '+%A')" \
			--set "$WIDGET.p2" label="$(date '+%d %B %Y')" \
			--set "$WIDGET.p3" label="week $(date '+%V') · day $(date '+%j') of $(date '+%Y')"
		;;
	clock)
		sketchybar \
			--set "$WIDGET.p1" label="$(date '+%H:%M:%S')" \
			--set "$WIDGET.p2" label="$(date '+%A, %d %B %Y')" \
			--set "$WIDGET.p3" label="up $(uptime | sed -E 's/.*up ([^,]+(, [0-9]+ users)?).*/\1/' | cut -c1-40)"
		;;
	battery)
		local batt
		batt=$(pmset -g batt)
		local pct
		pct=$(echo "$batt" | grep -Eo '[0-9]+%' | head -1)
		local src
		if echo "$batt" | grep -q 'AC Power'; then
			src="⚡ charging — $(echo "$batt" | grep -Eo '[0-9]+:[0-9]+ (to full|remaining)' | head -1)"
			[[ -z "$src" || "$src" == "⚡ charging — " ]] && src="⚡ on AC power"
		else
			src="🔋 on battery — $(echo "$batt" | grep -Eo '[0-9]+:[0-9]+ remaining' | head -1)"
		fi
		sketchybar \
			--set "$WIDGET.p1" label="Battery ${pct:-?}" \
			--set "$WIDGET.p2" label="$src" \
			--set "$WIDGET.p3" label="$(pmset -g batt | grep -o 'cycle count = [0-9]*' | head -1)"
		;;
	sound)
		local vol muted dev
		vol=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
		muted=$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)
		dev=$(SwitchAudioSource -c -t output 2>/dev/null)
		[[ "$muted" = "true" ]] && m="muted" || m="unmuted"
		sketchybar \
			--set "$WIDGET.p1" label="Volume ${vol:-?}%" \
			--set "$WIDGET.p2" label="output: ${m}" \
			--set "$WIDGET.p3" label="${dev:-default device}"
		;;
	cpu)
		local load top
		load=$(uptime | sed -E 's/.*load averages?: //' | cut -c1-20)
		top=$(ps -Ao %cpu,comm | sort -nrk1 | head -2 | tail -1 | awk '{printf "%s (%s%%)", $2, $1}')
		sketchybar \
			--set "$WIDGET.p1" label="CPU $(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f%%", s}')" \
			--set "$WIDGET.p2" label="load: $load" \
			--set "$WIDGET.p3" label="top: $top"
		;;
	spotify)
		local info
		info=$(osascript -e 'tell application "Spotify"
		if it is running then
			return (player state as text) & "|" & (name of current track) & "|" & (artist of current track) & "|" & (album of current track)
		end if
		end tell' 2>/dev/null)
		if [[ -z "$info" ]]; then
			sketchybar --set "$WIDGET.p1" label="Spotify not running"
			return
		fi
		IFS='|' read -r state title artist album <<< "$info"
		sketchybar \
			--set "$WIDGET.p1" label="$title" \
			--set "$WIDGET.p2" label="$artist — $album" \
			--set "$WIDGET.p3" label="state: $state · click ⏯ to toggle"
		;;
	esac
}

fill
sketchybar --animate tanh 12 --set "$WIDGET" popup.y_offset=12
sketchybar --set "$WIDGET" popup.drawing=toggle
