#!/usr/bin/env bash
# Syntax/structure validation for the whole repo. Zero side effects.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

fail=0
ok()   { printf '  \033[1;32m✓\033[0m %s\n' "$1"; }
bad()  { printf '  \033[1;31m✗\033[0m %s\n' "$1"; fail=1; }

log "Checking shell scripts"
while IFS= read -r -d '' f; do
  bash -n "$f" && ok "$f" || bad "$f"
done < <(find "$DOTFILES" -name '*.sh' -not -path "*/plugins/*" -print0)

log "Checking zsh config"
zsh -n "$DOTFILES/home/.zshrc" && ok "home/.zshrc" || bad "home/.zshrc"

PY=""
for cand in python3 python3.14 /opt/homebrew/bin/python3.14; do
  if command -v "$cand" >/dev/null 2>&1 && "$cand" -c "import tomllib" 2>/dev/null; then PY="$cand"; break; fi
done

log "Checking TOML configs"
while IFS= read -r -d '' f; do
  { [[ -n "$PY" ]] && "$PY" -c "import tomllib,sys; tomllib.load(open(sys.argv[1],'rb'))" "$f"; } \
    && ok "$f" || { [[ -z "$PY" ]] && warn "$f (no toml-capable python)"; [[ -n "$PY" ]] && bad "$f"; }
done < <(find "$DOTFILES" -name '*.toml' -print0)

log "Checking btop.conf (loose TOML)"
{ [[ -n "$PY" ]] && "$PY" -c "import tomllib; tomllib.load(open('$DOTFILES/.config/btop/btop.conf','rb'))"; } \
  && ok "btop.conf" || { [[ -z "$PY" ]] && warn "btop.conf (skipped)"; [[ -n "$PY" ]] && bad "btop.conf"; }

log "Checking JSON configs"
while IFS= read -r -d '' f; do
  python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$f" \
    && ok "$f" || bad "$f"
done < <(find "$DOTFILES" -name '*.json' -print0)

log "Checking Lua configs (sketchybar)"
if command -v luac &>/dev/null; then
  while IFS= read -r -d '' f; do
    luac -p "$f" && ok "$f" || bad "$f"
  done < <(find "$DOTFILES/.config/sketchybar" \( -name '*.lua' -o -name 'sketchybarrc' \) -type f -print0)
else
  warn "luac not installed — skipping Lua syntax check"
fi

log "Checking stow packages are non-empty"
for name in "${STOW_PKGS[@]}"; do
  if [[ -n "$(find "$DOTFILES/$name" -type f -print -quit 2>/dev/null)" ]]; then
    ok "$name/"
  else
    bad "$name/ (empty package)"
  fi
done

if (( fail )); then
  printf '\n\033[1;31mCHECKS FAILED\033[0m\n'
  exit 1
fi
printf '\n\033[1;32mALL CHECKS PASSED\033[0m\n'
