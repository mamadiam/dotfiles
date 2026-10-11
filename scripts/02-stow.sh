#!/usr/bin/env bash
# 02-stow: symlink configs into $HOME, backing up conflicts.
# Layout: .config package -> ~/.config (all app configs)
#         home package    -> $HOME    (dotfiles at $HOME level)
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Move any real file that blocks a stow link (never touches stow-owned
# symlinks — the readlink guard prevents repo-file self-moves).
backup_conflicts() {
  local pkg rel target had_conflict=0
  for pkg in .config home; do
    [[ -d "$DOTFILES/$pkg" ]] || continue
    while IFS= read -r -d '' f; do
      rel="${f#"$DOTFILES/$pkg"/}"
      target="$HOME/$rel"
      if [[ -L "$target" && ! -e "$target" ]]; then
        rm "$target"
        had_conflict=1
      elif [[ -e "$target" && "$(readlink -f "$target")" != "$DOTFILES"/* ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
        mv "$target" "$BACKUP_DIR/$rel"
        had_conflict=1
      fi
    done < <(find "$DOTFILES/$pkg" -type f -print0)
  done
  (( had_conflict )) && warn "Existing configs backed up to: $BACKUP_DIR"
}

log "Stowing .config -> ~/.config and home -> ~ (overwriting, with backup)"
backup_conflicts
stow --restow --dir "$DOTFILES" --target "$HOME/.config" .config
stow --restow --dir "$DOTFILES" --target "$HOME" home
