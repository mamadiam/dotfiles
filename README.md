# dotfiles

> **[Read the Manual →](MANUAL.md)** — how to drive the system, configure it, and make it yours.

One repo = my Mac, on any Mac I own.
Every Mac is reset to this standard in one command; whatever it replaces is backed up, never destroyed.

## Setup — any Mac
```sh
git clone https://github.com/YOU/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles && make        # or: ./install.sh
```
First run installs Homebrew itself. Re-run anytime — it's a "reset to my standard" button.

## Tasks
```
make help      show all tasks
make install   full setup (brew + stow + defaults + tools + services)
make update    git pull + re-apply (skips brew)
make check     validate every config (syntax only, no side effects)
make mobile    add the mobile dev layer (Xcode, Android Studio)
make clean     unlink all configs (repo untouched)
```

## Architecture
```
dotfiles/
├── Makefile              # entry point
├── install.sh            # thin orchestrator, ~30 lines
├── scripts/
│   ├── lib.sh            # shared helpers + pinned versions
│   ├── 01-brew.sh        # Homebrew + Brewfile(s)
│   ├── 02-stow.sh        # backup conflicts + symlink all packages
│   ├── 03-defaults.sh    # macOS defaults
│   ├── 04-tools.sh       # node LTS, pi, gh-copilot, rust, SBarLua, fonts
│   ├── 05-services.sh    # tpm, sketchybar/borders services
│   └── check.sh          # make check implementation
├── Brewfile              # ALL apps + CLI tools (the package doc)
├── Brewfile.mobile       # optional heavy GUI dev tools
├── macos/defaults.sh     # dock/finder/keyboard/animation settings
└── <app>/                # one stow package per app, mirrors $HOME paths
    └── .config/app/...   # e.g. aerospace/.config/aerospace/aerospace.toml
```

**The rule:** every layer is a file in this repo. Package = stowed into `$HOME`.
Infrastructure (scripts, Brewfile, themes/) lives outside packages and is never stowed.

## The 14 packages
zsh · git · aerospace (tiling WM) · karabiner (Hyper key) · ghostty (terminal) ·
tmux (ctrl-space prefix) · starship · yazi (files) · bat · btop ·
sketchybar (Lua menu bar) · borders (focus ring) · fastfetch · ubersicht (desktop clock) ·
lazygit (sumi-themed) · nvim (LazyVim starter)

## Themes — `make theme NAME=sumi|catppuccin`
Two complete looks, one switch. `scripts/theme.sh` re-points every themed app;
`make stow` (or a service restart) applies.

**sumi** (default) — *paper and ink*: warm bone on pure black, vermillion accent
on the frame only, hairline borders, near-square corners, Fraunces desktop clock
with a 力 seal. Design language adapted from [Ryoku](https://ryoku.dev)
(colors/metrics only — no code, see LICENSE-NOTE.md).

| App | sumi | catppuccin |
|---|---|---|
| ghostty | custom theme `sumi` (JetBrainsMono Nerd Font) | built-in `catppuccin-mocha` |
| tmux | hand-rolled statusline | hand-rolled statusline |
| sketchybar | `colors.lua` tokens, radius 6, vermillion seal | mauve accent, radius 9 |
| starship | `sumi` palette | `catppuccin_mocha` palette |
| yazi / btop | sumi rewrites | Mocha |
| bat | `ansi` (inherits terminal — color as data) | built-in Catppuccin |
| borders | vermillion frame | mauve frame |

Palette source of truth: `scripts/theme.sh` (simple lines) + `themes/` (complex
formats). Type system: Fraunces / Space Grotesk / JetBrainsMono NF / Noto Sans CJK.

## Key cheatsheet
| Where | Keys |
|---|---|
| Windows | `alt-h/j/k/l` focus · `alt-shift-h/j/k/l` move · `alt-f` fullscreen · `alt-t` float |
| Workspaces | `alt-1..5` switch · `alt-shift-1..5` send window |
| Global | Caps Lock = Hyper (hold) / Esc (tap) |
| tmux | `ctrl-space` prefix · `prefix+h/j/k/l` panes · `prefix+r` reload · `prefix+C-s` save session |
| Shell | `ctrl-r` history (atuin) · `fk` fix last command · `ai` opencode · `ask "..."` pipe LLM |
| Repo | `make check` · `dots add -A && dots commit` |

## AI ecosystem
| Tool | Role | How |
|------|------|-----|
| **opencode** | Main agent #1 — TUI coding agent | `ai` or `opencode` |
| **pi** | Main agent #2 — minimal extensible agent | `pi` |
| `mods` | LLMs on the pipe: `cat err.log \| ask "explain"` | `ask` |
| `gh copilot` | AI in the gh CLI | — |
| `ollama` | Local LLMs — `ollama run llama3` | — |
| `atuin` | Synced encrypted shell history (`atuin register` once) | `ctrl-r` |

API keys never go in this repo — put them in `~/.zshrc.local`:
```sh
export ANTHROPIC_API_KEY="sk-..."
```

## Dev stacks
- **Node**: fnm + LTS, auto-switches via `.nvmrc`
- **Python**: `uv` · **Rust**: `rustup` stable
- **Containers**: colima + docker CLI + lazydocker (`colima start`; k3s: `colima start --kubernetes`)
- **Mobile** (optional): `make mobile`
- **Web**: static-first Astro + Cloudflare Pages — needs nothing extra

## Per-machine + secrets
Gitignored local files, never edited in the repo:
- `~/.zshrc.local` — machine env vars, PATHs, API keys
- `~/.gitconfig.local` — per-machine git user

## Adding package #13 (the recipe)
1. `mkdir <app>/.config/<app>` and write the config mirroring `$HOME` paths
2. Add `<app>` to `STOW_PKGS` in `scripts/02-stow.sh`
3. Any new deps go in `Brewfile`, any setup in `scripts/04-tools.sh`
4. `make check`, then `make stow`
The orchestrator never changes.

## Credits / sources
All configs follow high-star, actively maintained projects: AeroSpace (23k★),
yabai, SketchyBar + FelixKratz/dotfiles (GPL-3.0, see LICENSE-NOTE.md),
catppuccin (19.8k★), tpm (15.1k★), atuin, opencode, pi, starship, delta,
zsh-autosuggestions — and the "remove animations / functional defaults"
style popularized by ChrisTitusTech's macutil.
