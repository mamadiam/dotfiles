# ~/.zshrc — sourced on every Mac I own
# Base inspired by Chris Titus maczsh style: aliases + starship + zoxide,
# upgraded with atuin, AI tools, and brew-managed plugins.

# --- history ---------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space autocd

# --- env -------------------------------------------------------------------
# keg-only formulae that must win on PATH
(( $+commands[brew] )) && export PATH="$(brew --prefix)/opt/trash/bin:$(brew --prefix)/opt/rustup/bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-R"
export LANG="en_US.UTF-8"

# --- safety ----------------------------------------------------------------
# rm goes to Trash (recoverable). bypass with \rm
command -v trash &>/dev/null && alias rm='trash -v'
alias cp='cp -i'
alias mv='mv -i'

# --- aliases ----------------------------------------------------------------
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first --git"
alias cat="bat --paging=never"
alias lg="lazygit"
alias fm="yazi"
alias info="macchina"
alias vi="nvim"
alias vim="nvim"
alias weather='curl wttr.in'

# yazi with cd-on-exit: quit yazi in a dir, the shell follows you there
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
alias g="git"
alias ..="cd .."
alias ...="cd ../.."
alias reload="source ~/.zshrc && echo reloaded"
alias ezrc="$EDITOR ~/.zshrc"
alias dots="git -C ~/Projects/dotfiles"   # manage this repo from anywhere: dots add, dots commit
alias da='date "+%Y-%m-%d %A %T %Z"'
alias whatismyip='curl -s ifconfig.me && echo'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# --- AI aliases ---------------------------------------------------------------
alias ai="opencode"               # main agent #1
alias pi_agent="pi"               # main agent #2 (kept explicit, `pi` is its CLI)
alias ask="mods"                  # pipe questions: cat file | ask "explain"

# --- fzf / zoxide ---------------------------------------------------------------
eval "$(zoxide init zsh)"
source <(fzf --zsh) 2>/dev/null || true

# --- prompt profile: starship (default) or p10k — set ZSH_PROMPT=p10k in ~/.zshrc.local
if [[ "${ZSH_PROMPT:-starship}" == "p10k" ]] && [[ -d "/opt/homebrew/share/powerlevel10k" ]]; then
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
  [[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
else
  eval "$(starship init zsh)"
fi

# --- fnm (node version manager, auto-switches .nvmrc/.node-version) ------------
command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd)"

# --- atuin (ctrl-r: synced, searchable shell history) --------------------------
command -v atuin &>/dev/null && eval "$(atuin init zsh)"

# --- direnv (per-project .envrc) ------------------------------------------------
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# --- thefuck (fix last command) — loaded lazily -------------------------------
command -v thefuck &>/dev/null && eval $(thefuck --alias fk)

# --- zsh plugins (installed via Brewfile; prefix works on Intel + Apple Silicon) -
if (( $+commands[brew] )); then
  BREW_SHARE="$(brew --prefix)/share"
  [[ -d "$BREW_SHARE/zsh-autosuggestions" ]] && source "$BREW_SHARE/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -d "$BREW_SHARE/zsh-syntax-highlighting" ]] && source "$BREW_SHARE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# --- system info on new terminal -----------------------------------------------
command -v fastfetch &>/dev/null && fastfetch

# --- per-machine / secrets (gitignored) -----------------------------------------
# Anything that differs per Mac or is secret goes in ~/.zshrc.local
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
