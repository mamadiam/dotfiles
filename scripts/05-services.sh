#!/usr/bin/env bash
# 05-services: start background services and plugin managers
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# --- tpm (tmux plugin manager) --------------------------------------------------
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]] && command -v git &>/dev/null; then
  log "Installing tpm (tmux plugin manager)"
  git clone --quiet https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# --- sketchybar + borders daemons --------------------------------------------------
for svc in sketchybar borders; do
  if brew list --cask &>/dev/null | grep -q "^$svc\$" || brew list &>/dev/null | grep -q "^$svc\$"; then
    log "Restarting $svc service"
    brew services restart "$svc" 2>/dev/null || warn "start $svc manually after first reboot"
  fi
done

# --- Übersicht (desktop wallpaper clock) ---------------------------------------------
if [[ -d "/Applications/Übersicht.app" ]]; then
  log "Launching Übersicht"
  open -g -a Übersicht 2>/dev/null || true
fi

warn "Reload AeroSpace config: aerospace reload-all (or re-login)"
warn "Install tmux plugins inside tmux: prefix + I"
