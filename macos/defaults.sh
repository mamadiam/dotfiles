#!/usr/bin/env bash
#
# macOS defaults — idempotent, safe to re-run on any machine.
# Each run overwrites whatever is currently set with MY preferred values.
#
set -euo pipefail

log() { printf '\033[1;33m-- %s\033[0m\n' "$1"; }

log "Dock"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock tilesize -int 28
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock orientation -string "left"

log "Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

log "Keyboard / input"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSWindowShouldDragOnGesture -bool true
defaults write com.apple.HIToolbox ApplePressAndHoldEnabled -bool false

log "Screen"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
mkdir -p "$HOME/Screenshots"
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

log "Mission Control"
defaults write com.apple.dock expose-animation-duration -int 0
defaults write com.apple.spaces spans-displays -bool false

log "Kill animations (Chris Titus macutil style: 'remove apple b.s.')"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock autohide-time-modifier -float 0

log "General"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write com.apple.finder WarnOnEmptyTrash -bool false

log "Appearance (paper is black — system follows)"
defaults write NSGlobalDomain _HIHideMenuBar -bool true  # sketchybar replaces it
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

log "Restarting affected apps"
killall Dock Finder SystemUIServer 2>/dev/null || true

log "Defaults applied (some need logout/restart to fully take effect)"
