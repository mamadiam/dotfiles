#!/usr/bin/env bash
# 04-tools: runtimes, AI agents, sketchybar's Lua runtime + fonts
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# --- Node LTS via fnm (pi + opencode need node 22.19+) ----------------------
if command -v fnm &>/dev/null; then
  log "Ensuring Node LTS (via fnm)"
  fnm install --lts 2>/dev/null || true
fi

# --- Rust toolchain -----------------------------------------------------------
if command -v rustup &>/dev/null && ! command -v cargo &>/dev/null; then
  log "Installing stable Rust toolchain"
  rustup default stable
fi

# --- gh-copilot (AI in the gh CLI) ---------------------------------------------
if command -v gh &>/dev/null; then
  log "Installing gh-copilot extension"
  gh extension install github/gh-copilot 2>/dev/null || true
fi

# --- gh-dash (GitHub PR/issue triage TUI; config vendored in .config/gh-dash/) --
if command -v gh &>/dev/null && ! gh extension list 2>/dev/null | grep -q "dlvhdr/gh-dash"; then
  log "Installing gh-dash extension"
  gh extension install dlvhdr/gh-dash 2>/dev/null || true
fi

# --- pi — AI agent toolkit (114k★) ----------------------------------------------
if ! command -v pi &>/dev/null; then
  log "Installing pi (AI coding agent)"
  curl -fsSL https://pi.dev/install.sh | sh
fi

# --- SbarLua (sketchybar's Lua engine), pinned to a commit ----------------------
if [[ ! -d "$HOME/.local/share/sketchybar_lua" ]]; then
  log "Building SbarLua (pinned @ $SBARLUA_COMMIT)"
  TMP=$(mktemp -d)
  git clone --quiet https://github.com/FelixKratz/SbarLua.git "$TMP/SbarLua"
  git -C "$TMP/SbarLua" -c advice.detachedHead=false checkout --quiet "$SBARLUA_COMMIT"
  (cd "$TMP/SbarLua" && make install)
  rm -rf "$TMP"
fi

# --- sketchybar-app-font (app icons in the bar) ----------------------------------
if [[ ! -f "$HOME/Library/Fonts/sketchybar-app-font.ttf" ]]; then
  log "Downloading sketchybar-app-font"
  curl -sfL "$SBAR_APP_FONT_URL" -o "$HOME/Library/Fonts/sketchybar-app-font.ttf"
fi

# --- Point docker CLI at colima, if the engine is running ------------------------
if command -v colima &>/dev/null && colima status 2>/dev/null | grep -q running; then
  log "Wiring docker context to colima"
  docker context use colima 2>/dev/null || true
fi
