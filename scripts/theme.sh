#!/usr/bin/env bash
# theme.sh — switch every themed app between sumi (paper-and-ink) and catppuccin.
#
#   scripts/theme.sh            apply sumi (default)
#   scripts/theme.sh catppuccin apply Mocha
#
# This file is the source of truth for the simple color lines (ghostty, bat,
# starship, btop, borders). Complex formats live as variant files under themes/
# and get copied into the packages. Run `make stow` afterwards (or restart the
# affected apps) — the configs are symlinks into this repo.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

THEME="${1:-sumi}"
case "$THEME" in
  sumi|catppuccin|tokyonight) ;;
  *) echo "unknown theme: $THEME (sumi | catppuccin)" >&2; exit 1 ;;
esac

# ── Palettes ────────────────────────────────────────────────────────────────
if [[ "$THEME" == "tokyonight" ]]; then
  # Partial theme: sketchybar only (variant file in themes/sketchybar/)
  :
elif [[ "$THEME" == "sumi" ]]; then
  # Paper and ink — warm bone on pure black (design language from Ryoku)
  GHOSTTY_THEME="sumi"
  BAT_THEME='--theme=ansi'                 # inherits the terminal palette
  STARSHIP_PALETTE='sumi'
  BTOP_THEME='sumi'
  BORDER_ACTIVE='0xffe2342a'               # vermillion — the frame carries the accent
else
  GHOSTTY_THEME="catppuccin-mocha"
  BAT_THEME='--theme="Catppuccin Mocha"'
  STARSHIP_PALETTE='catppuccin_mocha'
  BTOP_THEME='catppuccin_mocha'            # bundled with btop >= 1.3
  BORDER_ACTIVE='0xffcba6f7'               # mauve
fi

# Partial themes (e.g. tokyonight = sketchybar only) leave these empty
GHOSTTY_THEME="${GHOSTTY_THEME:-}"
BAT_THEME="${BAT_THEME:-}"
STARSHIP_PALETTE="${STARSHIP_PALETTE:-}"
BTOP_THEME="${BTOP_THEME:-}"
BORDER_ACTIVE="${BORDER_ACTIVE:-}"

sed_line() { # sed_line <file> <match> <replacement>
  if grep -q "$2" "$1" 2>/dev/null; then
    sed -i '' "s|$2|$3|" "$1"
  else
    warn "$1: pattern '$2' not found (skipped)"
  fi
}

# ── Simple color lines ──────────────────────────────────────────────────────
log "ghostty  → $GHOSTTY_THEME"
[[ -n "${GHOSTTY_THEME:-}" ]] && sed_line "$DOTFILES/ghostty/.config/ghostty/config" '^theme = .*' "theme = $GHOSTTY_THEME"

log "bat      → $BAT_THEME"
[[ -n "${BAT_THEME:-}" ]] && sed_line "$DOTFILES/bat/.config/bat/config" '^--theme=.*' "$BAT_THEME"

log "starship → $STARSHIP_PALETTE"
[[ -n "${STARSHIP_PALETTE:-}" ]] && sed_line "$DOTFILES/starship/.config/starship.toml" '^palette = .*' "palette = \"$STARSHIP_PALETTE\""

log "btop     → $BTOP_THEME"
[[ -n "${BTOP_THEME:-}" ]] && sed_line "$DOTFILES/btop/.config/btop/btop.conf" '^theme = .*' "theme = \"$BTOP_THEME\""

log "borders  → $BORDER_ACTIVE"
[[ -n "${BORDER_ACTIVE:-}" ]] && sed_line "$DOTFILES/borders/.config/bordersrc" '^active_color=.*' "active_color=$BORDER_ACTIVE"

# ── Complex formats: copy the variant into place ────────────────────────────
log "tmux     → $THEME"
f="$DOTFILES/themes/tmux-$THEME.conf"; [[ -f "$f" ]] && cp "$f" "$DOTFILES/tmux/.config/tmux/theme.conf"

log "yazi     → $THEME"
f="$DOTFILES/themes/yazi-$THEME.toml"; [[ -f "$f" ]] && cp "$f" "$DOTFILES/yazi/.config/yazi/theme.toml"

log "lazygit  → $THEME"
f="$DOTFILES/themes/lazygit-$THEME.yml"; [[ -f "$f" ]] && cp "$f" "$DOTFILES/lazygit/.config/lazygit/config.yml"

log "sketchybar → $THEME"
f="$DOTFILES/themes/sketchybar/$THEME.lua"; [[ -f "$f" ]] && cp "$f" "$DOTFILES/sketchybar/.config/sketchybar/colors.lua" || warn "no sketchybar variant for $THEME"

# ── Apply now if the configs are already live symlinks ──────────────────────
if [[ -L "$HOME/.config/sketchybar/colors.lua" ]]; then
  log "Restarting sketchybar + borders"
  brew services restart sketchybar 2>/dev/null || true
  brew services restart borders 2>/dev/null || true
fi

log "Theme '$THEME' applied. Run 'make stow' if configs weren't linked yet."
log "Live in tmux? Reload with: prefix + r"
