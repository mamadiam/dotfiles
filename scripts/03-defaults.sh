#!/usr/bin/env bash
# 03-defaults: apply macOS defaults (idempotent, overwrites with my values)
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

log "Applying macOS defaults"
bash "$DOTFILES/macos/defaults.sh"
