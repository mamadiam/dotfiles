#!/usr/bin/env bash
# 01-brew: Homebrew + all packages from Brewfile(s)
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# Xcode CLT is a Homebrew prerequisite (pattern from NLaundry/MacAutoSetup)
if ! xcode-select -p &>/dev/null; then
  log "Installing Xcode Command Line Tools"
  xcode-select --install
  until xcode-select -p &>/dev/null; do sleep 5; done
fi

if ! command -v brew &>/dev/null; then
  log "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(brew shellenv)"

# Newer brew refuses untrusted third-party taps
brew trust anomalyco/tap 2>/dev/null || true
brew trust FelixKratz/formulae 2>/dev/null || true
brew trust nikitabobko/tap 2>/dev/null || true

log "Installing packages via Brewfile"
brew bundle --file "$DOTFILES/Brewfile"

if [[ "${MOBILE:-0}" == "1" ]]; then
  log "Installing mobile dev layer (Xcode, Android Studio)"
  brew bundle --file "$DOTFILES/Brewfile.mobile"
fi
