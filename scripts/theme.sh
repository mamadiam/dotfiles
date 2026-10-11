#!/usr/bin/env bash
# theme.sh — switch the theme. carbon (john-json-inspired) is the default;
# catppuccin is the alternate.
#
#   scripts/theme.sh              apply carbon
#   scripts/theme.sh catppuccin   apply catppuccin
#
# This file is the source of truth for the simple color lines (ghostty, bat,
# starship, btop, borders). Complex formats live as variant files under themes/
# and get copied into the packages. Run `make stow` afterwards (or restart the
# affected apps) — the configs are symlinks into this repo.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

THEME="${1:-tokyonight}"
case "$THEME" in
  tokyonight|carbon|catppuccin) ;;
  *) echo "unknown theme: $THEME (tokyonight | carbon | catppuccin)" >&2; exit 1 ;;
esac

# ── Palettes ────────────────────────────────────────────────────────────────
if [[ "$THEME" == "tokyonight" ]]; then
  # tokyonight — Tokyonight Night (tcmmichaelb139-inspired setup)
  GHOSTTY_THEME="tokyonight"
  BAT_THEME='--theme=ansi'                 # inherits the terminal palette
  STARSHIP_PALETTE='tokyonight'
  BTOP_THEME='tokyo_night'                 # bundled with btop >= 1.3
  BORDER_ACTIVE='0xff7aa2f7'               # tokyonight blue
elif [[ "$THEME" == "carbon" ]]; then
  # carbon — muted dark scheme inspired by john-json/dotfiles
  GHOSTTY_THEME="carbon"
  BAT_THEME='--theme=ansi'                 # inherits the terminal palette
  STARSHIP_PALETTE='carbon'
  BTOP_THEME='carbon'
  BORDER_ACTIVE='0x99dcaf6c'               # warm yellow, 60%
else
  GHOSTTY_THEME="catppuccin-mocha"
  BAT_THEME='--theme="Catppuccin Mocha"'
  STARSHIP_PALETTE='catppuccin_mocha'
  BTOP_THEME='catppuccin_mocha'            # bundled with btop >= 1.3
  BORDER_ACTIVE='0xffcba6f7'               # mauve
fi

sed_line() { # sed_line <file> <match> <replacement>
  if grep -q "$2" "$1" 2>/dev/null; then
    sed -i '' "s|$2|$3|" "$1"
  else
    warn "$1: pattern '$2' not found (skipped)"
  fi
}

# ── Simple color lines ──────────────────────────────────────────────────────
log "ghostty  → $GHOSTTY_THEME"
sed_line "$DOTFILES/.config/ghostty/config" '^theme = .*' "theme = $GHOSTTY_THEME"

log "bat      → $BAT_THEME"
sed_line "$DOTFILES/.config/bat/config" '^--theme=.*' "$BAT_THEME"

log "starship → $STARSHIP_PALETTE"
sed_line "$DOTFILES/.config/starship.toml" '^palette = .*' "palette = \"$STARSHIP_PALETTE\""

log "btop     → $BTOP_THEME"
sed_line "$DOTFILES/.config/btop/btop.conf" '^theme = .*' "theme = \"$BTOP_THEME\""

log "borders  → $BORDER_ACTIVE"
sed_line "$DOTFILES/.config/bordersrc" '^active_color=.*' "active_color=$BORDER_ACTIVE"

# ── Complex formats: copy the variant into place ────────────────────────────
log "tmux     → $THEME"
f="$DOTFILES/themes/tmux-$THEME.conf"; [[ -f "$f" ]] && cp "$f" "$DOTFILES/.config/tmux/theme.conf"

log "yazi     → $THEME"
f="$DOTFILES/themes/yazi-$THEME.toml"; [[ -f "$f" ]] && cp "$f" "$DOTFILES/.config/yazi/theme.toml"

log "lazygit  → $THEME"
f="$DOTFILES/themes/lazygit-$THEME.yml"; [[ -f "$f" ]] && cp "$f" "$DOTFILES/.config/lazygit/config.yml"

log "sketchybar → $THEME"
f="$DOTFILES/themes/sketchybar/$THEME.lua"; [[ -f "$f" ]] && cp "$f" "$DOTFILES/.config/sketchybar/colors.lua" || warn "no sketchybar variant for $THEME"

# ── Apply now if the configs are already live symlinks ──────────────────────
if [[ -L "$HOME/.config/sketchybar/colors.lua" ]]; then
  log "Restarting sketchybar + borders"
  brew services restart sketchybar 2>/dev/null || true
  brew services restart borders 2>/dev/null || true
fi

log "Theme '$THEME' applied. Run 'make stow' if configs weren't linked yet."
log "Live in tmux? Reload with: prefix + r"
