#!/usr/bin/env bash
# wm.sh — switch window manager profile: aerospace (default) or yabai+skhd.
#
#   scripts/wm.sh aerospace    AeroSpace tiling (default)
#   scripts/wm.sh yabai        yabai + skhd (john-json style)
#
# yabai note: tiling works out of the box, but animations and Space control
# require partially disabling SIP (recovery mode: csrutil disable --partial
# --with-music) — that is a personal security trade-off, not done by default.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

WM="${1:-aerospace}"
case "$WM" in
  aerospace|yabai) ;;
  *) echo "unknown wm: $WM (aerospace | yabai)" >&2; exit 1 ;;
esac

if [[ "$WM" == "yabai" ]]; then
  log "Stopping AeroSpace, starting yabai + skhd"
  osascript -e 'quit app "AeroSpace"' 2>/dev/null || killall AeroSpace 2>/dev/null || true
  brew services restart yabai 2>/dev/null || warn "brew services start yabai (needs to run once as your user)"
  brew services restart skhd 2>/dev/null || true
  warn "yabai animations/Spaces need partial SIP disable (see MANUAL §10)"
else
  log "Stopping yabai + skhd, starting AeroSpace"
  brew services stop yabai 2>/dev/null || true
  brew services stop skhd 2>/dev/null || true
  pkill -f islandhelper 2>/dev/null || true
  open -a AeroSpace
fi
log "WM profile: $WM"
