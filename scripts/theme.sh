#!/usr/bin/env bash
# theme.sh — apply the theme (catppuccin is currently the only theme).
#
#   scripts/theme.sh            apply catppuccin (default)
#
# This file is the source of truth for the simple color lines (ghostty, bat,
# starship, btop, borders). Complex formats live as variant files under themes/
# and get copied into the packages. Run `make stow` afterwards (or restart the
# affected apps) — the configs are symlinks into this repo.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

THEME="${1:-catppuccin}"
case "$THEME" in
  catppuccin) ;;
  *) echo "unknown theme: $THEME (catppuccin)" >&2; exit 1 ;;
esac

GHOSTTY_THEME="catppuccin-mocha"
BAT_THEME='--theme="Catppuccin Mocha"'
STARSHIP_PALETTE='catppuccin_mocha'
BTOP_THEME='catppuccin_mocha'
BORDER_ACTIVE='0xffcba6f7'                 # mauve

sed_line() { # sed_line <file> <match> <replacement>
  if grep -q "$2" "$1" 2>/dev/null; then
    sed -i '' "s|$2|$3|" "$1"
  else
    warn "$1: pattern '$2' not found (skipped)"
  fi
}

log "ghostty  → $GHOSTTY_THEME"
sed_line "$DOTFILES/ghostty/.config/ghostty/config" '^theme = .*' "theme = $GHOSTTY_THEME"

log "bat      → $BAT_THEME"
sed_line "$DOTFILES/bat/.config/bat/config" '^--theme=.*' "$BAT_THEME"

log "starship → $STARSHIP_PALETTE"
sed_line "$DOTFILES/starship/.config/starship.toml" '^palette = .*' "palette = \"$STARSHIP_PALETTE\""

log "btop     → $BTOP_THEME"
sed_line "$DOTFILES/btop/.config/btop/btop.conf" '^theme = .*' "theme = \"$BTOP_THEME\""

log "borders  → $BORDER_ACTIVE"
sed_line "$DOTFILES/borders/.config/bordersrc" '^active_color=.*' "active_color=$BORDER_ACTIVE"

log "tmux     → $THEME"
f="$DOTFILES/themes/tmux-$THEME.conf"; [[ -f "$f" ]] && cp "$f" "$DOTFILES/tmux/.config/tmux/theme.conf"

log "yazi     → $THEME"
f="$DOTFILES/themes/yazi-$THEME.toml"; [[ -f "$f" ]] && cp "$f" "$DOTFILES/yazi/.config/yazi/theme.toml"

log "sketchybar → $THEME"
f="$DOTFILES/themes/sketchybar/$THEME.lua"; [[ -f "$f" ]] && cp "$f" "$DOTFILES/sketchybar/.config/sketchybar/colors.lua" || warn "no sketchybar variant for $THEME"

if [[ -L "$HOME/.config/sketchybar/colors.lua" ]]; then
  log "Restarting sketchybar + borders"
  brew services restart sketchybar 2>/dev/null || true
  brew services restart borders 2>/dev/null || true
fi

log "Theme '$THEME' applied. Run 'make stow' if configs weren't linked yet."
log "Live in tmux? Reload with: prefix + r"
