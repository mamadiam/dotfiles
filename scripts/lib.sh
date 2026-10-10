#!/usr/bin/env bash
# Shared helpers for all setup scripts. Sourced, never executed.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[1]}")/.." && pwd)"

command -v brew &>/dev/null && eval "$(brew shellenv)" 2>/dev/null || true

log()  { printf '\033[1;36m==> %s\033[0m\n' "$1"; }
warn() { printf '\033[1;33m !  %s\033[0m\n' "$1"; }

# Pinned versions — bump here, nowhere else
SBARLUA_COMMIT="dba9cc421b868c918d5c23c408544a28aadf2f2f"  # 2026-03-06, lua 5.5.0
SBAR_APP_FONT_URL="https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf"

machine() { scutil --ComputerName 2>/dev/null || hostname -s; }
