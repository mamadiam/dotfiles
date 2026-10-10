#!/usr/bin/env bash
#
# Bootstrap any Mac to MY standard. Idempotent: safe to re-run anytime.
# Whatever existing files it replaces are backed up, never destroyed.
#
#   ./install.sh              full setup (brew + stow + defaults + tools + services)
#   ./install.sh --no-brew    skip brew bundle (fast re-apply)
#   ./install.sh --defaults   only apply macOS defaults
#   ./install.sh --mobile     ALSO install mobile dev layer (Xcode, Android Studio)
#
# Real logic lives in scripts/01..05 — each runs standalone.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP_BREW=0
for arg in "$@"; do
  case "$arg" in
    --no-brew)  SKIP_BREW=1 ;;
    --defaults) exec bash "$DOTFILES/scripts/03-defaults.sh" ;;
    --mobile)   export MOBILE=1 ;;
    *) echo "unknown flag: $arg" >&2; exit 1 ;;
  esac
done

run() { printf '\033[1;36m==> [ %s ]\033[0m\n' "$1"; bash "$DOTFILES/scripts/$1.sh"; }

[[ "$SKIP_BREW" == "0" ]] && run 01-brew
run 02-stow
run 03-defaults
run 04-tools
run 05-services

printf '\n\033[1;36m==> Setup complete on: %s\033[0m\n' "$(scutil --ComputerName 2>/dev/null || hostname -s)"
echo "Per-machine overrides → ~/.zshrc.local (gitignored)"
