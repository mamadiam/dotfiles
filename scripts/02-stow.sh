#!/usr/bin/env bash
# 02-stow: symlink every package into $HOME, backing up conflicts.
# To add a new app config: mkdir <app>/, put config inside mirroring
# $HOME paths, then add <app> to STOW_PKGS below.
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

STOW_PKGS=(zsh git aerospace karabiner ghostty tmux starship yazi bat btop sketchybar borders fastfetch ubersicht)

BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Any real file (not one of our symlinks) in the way gets moved to
# $BACKUP_DIR, so this script can safely take over an in-use Mac.
backup_conflicts() {
  local pkg rel target had_conflict=0
  for pkg in "${STOW_PKGS[@]}"; do
    [[ -d "$DOTFILES/$pkg" ]] || continue
    while IFS= read -r -d '' f; do
      rel="${f#"$DOTFILES/$pkg"/}"
      target="$HOME/$rel"
      if [[ -L "$target" && ! -e "$target" ]]; then
        # Dangling symlink from a previous setup — target is already gone
        rm "$target"
        had_conflict=1
      elif [[ -e "$target" ]]; then
        # Real file or live symlink not owned by us — back it up
        mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
        mv "$target" "$BACKUP_DIR/$rel"
        had_conflict=1
      fi
    done < <(find "$DOTFILES/$pkg" -type f -print0)
  done
  (( had_conflict )) && warn "Existing configs backed up to: $BACKUP_DIR"
}

log "Stowing ${#STOW_PKGS[@]} packages (overwriting, with backup)"
backup_conflicts
stow --restow --dir "$DOTFILES" --target "$HOME" "${STOW_PKGS[@]}"
