#!/usr/bin/env bash
# Syntax/structure validation for the whole repo. Zero side effects.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

fail=0
ok()   { printf '  \033[1;32m✓\033[0m %s\n' "$1"; }
bad()  { printf '  \033[1;31m✗\033[0m %s\n' "$1"; fail=1; }

log "Checking shell scripts"
while IFS= read -r -d '' f; do
  bash -n "$f" && ok "$f" || bad "$f"
done < <(find "$DOTFILES" -name '*.sh' -print0)

log "Checking zsh config"
zsh -n "$DOTFILES/zsh/.zshrc" && ok "zsh/.zshrc" || bad "zsh/.zshrc"

log "Checking TOML configs"
while IFS= read -r -d '' f; do
  python3 -c "import tomllib,sys; tomllib.load(open(sys.argv[1],'rb'))" "$f" \
    && ok "$f" || bad "$f"
done < <(find "$DOTFILES" -name '*.toml' -print0)

log "Checking btop.conf (loose TOML)"
python3 -c "import tomllib; tomllib.load(open('$DOTFILES/btop/.config/btop/btop.conf','rb'))" \
  && ok "btop.conf" || bad "btop.conf"

log "Checking JSON configs"
while IFS= read -r -d '' f; do
  python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$f" \
    && ok "$f" || bad "$f"
done < <(find "$DOTFILES" -name '*.json' -print0)

log "Checking Lua configs (sketchybar)"
if command -v luac &>/dev/null; then
  while IFS= read -r -d '' f; do
    luac -p "$f" && ok "$f" || bad "$f"
  done < <(find "$DOTFILES/sketchybar" \( -name '*.lua' -o -name 'sketchybarrc' \) -type f -print0)
else
  warn "luac not installed — skipping Lua syntax check"
fi

log "Checking stow packages are non-empty"
for d in "$DOTFILES"/*/; do
  name=$(basename "$d")
  [[ "$name" == "scripts" || "$name" == "macos" || "$name" == "themes" ]] && continue
  if find "$d" -type f | grep -q .; then
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
