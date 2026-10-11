# dotfiles

> **[Read the Manual →](MANUAL.md)** — how to drive the system, configure it, and make it yours.

One repo = my Mac, on any Mac I own.
Every Mac is reset to this standard in one command; whatever it replaces is backed up, never destroyed.

## Setup — any Mac
```sh
git clone https://github.com/mamadiam/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles && make        # or: ./install.sh
```
Private repo — authenticate first (`gh auth login` or your SSH key). First run installs Homebrew itself, then ~60 packages, symlinks every config (backing up whatever it replaces to `~/dotfiles-backup-*`), applies macOS defaults, builds the tools that need building, and starts the services. Budget 15–20 minutes, then **log out and back in**. Re-run anytime — it's a "reset to my standard" button.

## Tasks
```
make help      show all tasks
make install   full setup (brew + stow + defaults + tools + services)
make update    git pull + re-apply (skips brew)
make check     validate every config (syntax only, no side effects)
make theme     re-apply the carbon theme (NAME=catppuccin switches)
make mobile    add the mobile dev layer (Xcode, Android Studio)
make clean     unlink all configs (repo untouched)
```

## Architecture
```
dotfiles/
├── Makefile              entry point
├── install.sh            thin orchestrator, ~30 lines
├── scripts/
│   ├── lib.sh            shared helpers + pinned versions
│   ├── 01-brew.sh        Homebrew + Brewfile(s)
│   ├── 02-stow.sh        backup conflicts + symlink all packages
│   ├── 03-defaults.sh    macOS defaults
│   ├── 04-tools.sh       node LTS, pi, gh-copilot, rust, SBarLua, fonts
│   ├── 05-services.sh    tpm, sketchybar/borders services
│   ├── theme.sh          make theme implementation
│   └── check.sh          make check implementation
├── Brewfile              ALL apps + CLI tools (the package doc)
├── Brewfile.mobile       optional heavy GUI dev tools
├── macos/defaults.sh     dock/finder/keyboard/animation settings
├── themes/               per-app theme variant files (carbon is live)
├── .config/              ALL app configs — ONE stow package → ~/.config
└── home/                 $HOME-level dotfiles — second stow package
```

**The rule:** every layer is a file in this repo. Two stow packages only (defined once, in `scripts/lib.sh`): `.config` links into `~/.config`, `home` links into `$HOME`. Infrastructure (scripts, Brewfile, `themes/`, `macos/`) lives outside the packages and is never stowed.

## The apps
zsh · git · aerospace (tiling WM) · karabiner (Hyper key) · ghostty (terminal) ·
tmux (ctrl-space prefix) · starship · yazi (files) · bat · btop ·
sketchybar (Lua menu bar) · borders (focus ring) · fastfetch · ubersicht (desktop clock) ·
lazygit (carbon-themed) · nvim (LazyVim starter)

## Theme
**Carbon** (muted charcoal + warm yellow `#dcaf6c`, john-json-inspired) is the live theme everywhere: Ghostty, tmux, SketchyBar, starship, yazi, bat, btop, lazygit and the Borders focus ring. `make theme NAME=catppuccin` switches to the mocha alternate. A Ryoku paper-and-ink theme is planned — infra ready in `scripts/theme.sh` + `themes/`.

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

## Adding an app (the recipe)
1. `mkdir -p .config/<app>` and write the config mirroring its real `$HOME` path — the `.config` stow package picks it up automatically, no registration needed
2. New dependencies go in `Brewfile`; any setup logic in `scripts/04-tools.sh`
3. `make check`, then `make stow`

The orchestrator never changes.

## Credits / sources
All configs follow high-star, actively maintained projects: AeroSpace (23k★),
SketchyBar + FelixKratz/dotfiles (GPL-3.0, see LICENSE-NOTE.md), the john-json
carbon palette, tpm (15.1k★), atuin, opencode, pi, starship, delta,
zsh-autosuggestions — and the "remove animations / functional defaults"
style popularized by ChrisTitusTech's macutil.
