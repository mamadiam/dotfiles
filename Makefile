# dotfiles task runner — one entry point for everything
.DEFAULT_GOAL := install
.PHONY: install update mobile defaults check stow theme clean

install:            ## full setup (brew + stow + defaults + tools + services)
	./install.sh

update:             ## pull latest + re-apply without re-brewing
	git pull --ff-only
	./install.sh --no-brew

mobile:             ## install the mobile dev layer (Xcode, Android Studio)
	./install.sh --mobile

defaults:           ## apply macOS defaults only
	./install.sh --defaults

stow:               ## re-symlink configs only
	bash scripts/02-stow.sh

theme:              ## switch theme: make theme NAME=sumi (or NAME=catppuccin)
	bash scripts/theme.sh $(NAME)

check:              ## validate all configs (syntax, no side effects)
	bash scripts/check.sh

clean:              ## remove all symlinks (configs stay in repo)
	stow -D --dir . --target $$HOME zsh git aerospace karabiner ghostty tmux starship yazi bat btop sketchybar borders fastfetch ubersicht

help:               ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'
