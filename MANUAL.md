# The Manual

**力と美のために** — *for the sake of power and beauty.*

This is a complete, opinionated macOS workstation built on [Ghostty](https://ghostty.org), the tiling window manager [AeroSpace](https://aerospaceconfig.com), the Lua status bar [SketchyBar](https://github.com/FelixKratz/SketchyBar), and one repository that reproduces all of it on any Mac you own. It ships with the terminal stack, the ricing, the AI agents, and the dev toolchains already wired together. There is zero bloat here: just everything needed, arranged with taste.

This manual is how you drive it. It's organized in the order you'll need things: daily driving first, configuration second, internals last.

---

## Table of contents

1. [The philosophy](#1-the-philosophy)
2. [Getting started](#2-getting-started)
3. [Navigation — AeroSpace](#3-navigation--aerospace)
4. [The top bar — SketchyBar](#4-the-top-bar--sketchybar)
5. [The terminal](#5-the-terminal)
6. [Themes](#6-themes)
7. [The desktop clock](#7-the-desktop-clock)
8. [AI](#8-ai)
9. [TUIs](#9-tuis)
10. [Development tools](#10-development-tools)
11. [How the dotfiles work](#11-how-the-dotfiles-work)
12. [Adding a package](#12-adding-a-package)
13. [Making your own theme](#13-making-your-own-theme)
14. [Updates & maintenance](#14-updates--maintenance)
15. [Troubleshooting](#15-troubleshooting)
16. [Uninstalling](#16-uninstalling)
17. [Credits](#17-credits)

---

## 1. The philosophy

Three rules hold the whole system together. Everything else follows from them.

**One repo = one Mac.** If a setting can't be reproduced from this repository plus `make install`, it doesn't count. You never "configure a Mac" — you configure the repo, and every Mac you own converges to it. A fresh machine is a deployment target, not a project.

**Everything is a file.** No hidden preference panes, no GUI config apps, no settings stored in opaque databases. Your prompt is a TOML file. Your bar is Lua. Your window manager is TOML. If you can edit a file, you can change anything.

**Restraint is the aesthetic.** Clean surfaces, one accent, no visual noise. The current theme is **Catppuccin Mocha**; a Ryoku-inspired paper-and-ink theme is the next planned look. See [Themes](#6-themes).

---

## 2. Getting started

### On a new Mac

```sh
git clone https://github.com/YOU/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
make install
```

First run installs Homebrew itself (and Xcode CLT if missing), then ~55 packages, symlinks every config (backing up whatever it replaces to `~/dotfiles-backup-*`), applies macOS defaults, builds the tools that need building, and starts the services. Budget 15–20 minutes, then **log out and back in** — Karabiner and AeroSpace both want that.

### The one-time rituals

| Ritual | Why |
|---|---|
| Grant **Accessibility** to AeroSpace (System Settings → Privacy & Security) | Tiling can't see windows without it |
| Grant **Accessibility** to Karabiner-Elements | Same, for the keyboard |
| `tmux`, then `ctrl-space` + `I` | Installs tmux plugins (sessions that survive reboots) |
| `atuin register` | Shell history, encrypted-synced across all your Macs |
| `opencode` → `/connect`, `pi` → `/login` | AI agents, your API keys |
| `gh auth login` | GitHub auth for git pushes over HTTPS |

### The two files you own privately

`~/.zshrc.local` and `~/.gitconfig.local` are gitignored, sourced last, and never leave the machine. Machine-specific PATHs, work identities, API keys — that's where they live. The repo provides the system; these files provide *your* context on *this* machine.

---

## 3. Navigation — AeroSpace

The mouse is for browsers. Everything else is keys.

### Windows

| Keys | Action |
|---|---|
| `alt-h j k l` or `alt-arrows` | Focus left / down / up / right |
| `alt-shift-h j k l` or `alt-shift-arrows` | Move window |
| `alt-shift-minus` / `alt-shift-equal` | Shrink / grow |
| `alt-f` | Fullscreen |
| `alt-t` | Float / tile toggle |
| `alt-e` | Flip layout |
| `alt-shift-slash` | Service mode (reload config, flatten tree, close others) |

### Workspaces

| Keys | Action |
|---|---|
| `alt-1..5` | Jump to workspace |
| `alt-shift-1..5` | Throw window to workspace |
| Click a number in the bar | Same thing |

Bonus, from macOS itself: hold `ctrl+cmd` and drag **anywhere on a window** to move it (no title bar needed). And `ctrl+cmd+click` still drags.

### Making windows land where they belong

Uncomment the `[on-window-detected]` block at the bottom of `aerospace/.config/aerospace/aerospace.toml` to auto-assign apps — browser to workspace 2, chat to 5, and so on. It's commented rather than pre-configured because your app layout is yours.

---

## 4. The top bar — SketchyBar

The bar is not a menu bar. It's a live instrument, configured entirely in Lua:

```
力  1  2  3  4  5    FRONT-APP            media · volume · battery · wifi · clock
└ seal  └ workspaces with app icons         └ right side widgets
```

- **The seal** (`力`, "power") — the brand mark. Purple/vermillion depending on theme.
- **Workspaces 1–5** — live app icons per workspace (via the sketchybar-app-font), the active one glowing in the accent color. **Click to jump.**
- **Media strip** — grows the artist/title when music plays, with transport controls on hover.
- **Volume** — scroll to change, click for the device picker popup, right-click for Sound settings.
- **Battery** — color shifts green → ochre → red as it drains; click for time remaining.
- **Wifi** — SSID on hover, click for Network settings.
- **Clock** — day, date, time. Click opens Calendar.

The system menu bar is hidden (see `macos/defaults.sh`) — the bar you see is *the* bar. AeroSpace's own icon lives in the hidden menu bar; the workspace items in SketchyBar are your real indicator.

Everything lives in `sketchybar/.config/sketchybar/`: `colors.lua` is the token file (one place for the whole look), `items/` is one file per widget. Change `colors.lua`, then `brew services restart sketchybar`.

---

## 5. The terminal

**Ghostty** draws it: sumi or themed colors, JetBrainsMono Nerd Font, copy-on-select.

**Plain zsh** runs it — deliberately no oh-my-zsh. What you get instead:

| Tool | What it does | The key |
|---|---|---|
| **starship** | The prompt: 力, directory, git branch, language versions, exit status | — |
| **zsh-autosuggestions** | Ghost text from history | `→` to accept |
| **zsh-syntax-highlighting** | Valid commands green, typos red, as you type | — |
| **atuin** | Searchable, synced, encrypted history | `ctrl-r` |
| **fzf** | Fuzzy everything | `ctrl-t` files, `alt-c` cd |
| **thefuck** | Fixes your last typo'd command | `fk` |
| **zoxide** | `z partial-name` jumps to any dir you've been | `z` |
| **eza / bat / fd / rg** | ls / cat / find / grep, modernized | aliases already set |

Aliases worth knowing: `ll`, `cat` (→ bat), `lg` (lazygit), `dots` (git manage this repo from anywhere), `ezrc` (edit zshrc), `reload`, `whatismyip`, `flushdns`. `rm` goes to Trash — bypass with `\rm` if you mean it.

tmux (`ctrl-space` prefix) gives sessions that survive everything: `prefix+h/j/k/l` panes, `prefix+r` reload, `prefix+ctrl-s` save, and continuum auto-restores after reboot.

---

## 6. Themes

**Carbon** is the default theme, everywhere: Ghostty, tmux, SketchyBar,
starship, yazi, bat, btop, lazygit and the Borders focus ring. One palette,
one mood — soft pastels on a mocha base, mauve accent.

Re-apply it any time (also re-runs after you edit any theme file):

```sh
make theme                    # carbon (default)
make theme NAME=catppuccin    # soft pastels
```

Carbon — muted charcoal + warm yellow, from [john-json/dotfiles](https://github.com/john-json/dotfiles)' palette.

**More themes are coming.** A deep-dive into [Ryoku](https://github.com/Ryoku-dev/ryoku)'s
paper-and-ink design language ("sumi") is planned as the next major theme.
The theme infrastructure (`scripts/theme.sh` + `themes/`) is already built for
it — see [Making your own theme](#13-making-your-own-theme).

## 7. The desktop clock

[Übersicht](https://github.com/felixhageloh/uebersicht) renders `ubersicht/.config/ubersicht/widgets/sumi-clock.jsx`: a 132px Fraunces clock, the 力 seal, and a tracked uppercase date — resting on the wallpaper, bottom left, with a soft shadow for legibility on any background. Nothing else asks for attention.

Want it somewhere else? Edit the `bottom`/`left` percentages in the JSX. Want it gone? `open Übersicht` → menu → *Refresh all*, or quit the app. It comes back on login (that's `scripts/05-services.sh`).

---

## 8. AI

The agents are first-class citizens here, not add-ons.

| Tool | Role | Entry |
|---|---|---|
| **opencode** | Primary agent — TUI coding with providers of your choice | `ai` or `opencode` |
| **pi** | Minimal, extensible agent harness — make it yours | `pi` |
| **mods** | LLMs on the pipe | `cat error.log \| ask "explain this"` |
| **gh copilot** | AI inside the gh CLI | `gh copilot suggest "…"` |
| **ollama** | Local models, zero cloud | `ollama run llama3` |

API keys never touch this repo. `~/.zshrc.local` carries them:

```sh
export ANTHROPIC_API_KEY="sk-…"
export OPENAI_API_KEY="sk-…"
```

`install.sh` also installs the `gh-copilot` extension when it finds `gh`. opencode reads `AGENTS.md` in your projects — commit one per project and the agents inherit your conventions.

---

## 9. TUIs

All installed, all themed:

- **yazi** — file manager with image previews (`yazi`). Vim keys, tabs, bulk rename.
- **lazygit** — git as it should be (`lg`). Interactive rebase you'll actually use.
- **btop** — system monitor (`btop`), theme follows the system.
- **lazysql** — SQL browser TUI (`lazysql`).
- **delta** — side-by-side git diffs with line numbers, wired into gitconfig.
- **tmux + tpm** — resurrect/continuum mean your sessions survive reboots.

---

## 10. Development tools

- **Node** — `fnm` + LTS. Drop a `.nvmrc` in a project; the shell switches on `cd`.
- **Python** — `uv`. `uv venv`, `uv pip install`, `uv run`. No pyenv, no poetry, no venv activation dance.
- **Rust** — `rustup` stable, installed on first run.
- **Containers** — `colima start` boots a lightweight Docker engine (no Docker Desktop). `lazydocker` for the TUI. Kubernetes itch? `colima start --kubernetes` gives you k3s; `kubectl` is preinstalled.
- **GNU utils** — `gsed`, `greadlink`, `gfind`, `gawk` — your Linux muscle memory works.
- **Cloud** — `awscli`, `tailscale`.
- **Mobile** — `make mobile` adds Xcode + Android Studio (skipped by default; they're huge).

---

## 11. How the dotfiles work

```
~/Projects/dotfiles/
├── Makefile              entry point: install, update, check, theme, stow, clean
├── install.sh            thin orchestrator → scripts/01..05
├── scripts/              one job per script, runnable standalone
├── Brewfile              every package (the real package doc)
├── themes/               palette variants for the theme switcher
├── macos/defaults.sh     macOS settings, idempotent
└── <app>/                one stow package per app, mirrors $HOME
    └── .config/app/…     ghostty/, tmux/, sketchybar/, aerospace/, …
```

**Stow is the whole magic.** `stow` symlinks each package's contents into `$HOME`. `~/.zshrc` *is* `~/Projects/dotfiles/zsh/.zshrc`. Edit the file in the repo and it's live — there is no copy step, no sync, no build. That's why `dots commit -am "tweak"` from anywhere is the whole workflow.

**Before every commit:**

```sh
make check      # syntax-validates every script, config, theme — no side effects
```

**Manage the repo from anywhere:**

```sh
dots add -A && dots commit -m "fix: ghostty padding" && dots push
```

**Per-machine reality** lives in two gitignored files (`~/.zshrc.local`, `~/.gitconfig.local`), sourced last so they always win. Work git identity? See the commented `includeIf` block at the bottom of `.gitconfig`.

---

## 12. Adding a package

App #17 takes five minutes, and the orchestrator never changes:

1. `mkdir -p <app>/.config/<app>` and write the config, mirroring its real `$HOME` path
2. Add `<app>` to `STOW_PKGS` in `scripts/02-stow.sh`
3. New dependencies go in `Brewfile`; any setup logic in `scripts/04-tools.sh`
4. `make check`, then `make stow`

Everything that applies to one app stays in one directory. If you need something another package already has, reference it — never copy it.

---

## 13. Making your own theme

A theme is two things: color lines in `scripts/theme.sh` (simple cases) and variant files under `themes/` (complex formats).

1. Pick a palette. Steal from a star repository — [Catppuccin](https://github.com/catppuccin/catppuccin), [Tokyo Night](https://github.com/folke/tokyonight.nvim), [Rosé Pine](https://rosepinetheme.com), [Gruvbox](https://github.com/morhetz/gruvbox) all have ports for most of these apps already.
2. Add your name to the `case` in `scripts/theme.sh` with the five simple values (ghostty theme, bat theme, starship palette, btop theme, borders color).
3. Add variant files for the apps you want: `themes/sketchybar/<name>.lua` (start by copying one — it's the token file: ink ramp, accent, bg tiers, radius), plus tmux/yazi/lazygit variants if you want them themed too.
4. Missing variants are skipped with a warning — a theme may cover any subset.
5. `make theme NAME=<yours>` · restart the bar · live.

Rule from the source of the design language: don't define values inside components. `colors.lua` is the one place the bar's look lives; if a value is missing, add it *there*.

---

## 14. Updates & maintenance

```sh
make update     # git pull + re-apply everything (skips brew)
brew bundle     # new/changed packages
brew upgrade    # bump everything brew owns
make check      # before every commit
```

`make install` (and every script in `scripts/`) is **idempotent** — re-running is always safe and always converges the Mac back to the repo's state. Think of it as a reset button, not an installer. Whatever it replaces lands in `~/dotfiles-backup-<date>/`, never `/dev/null`.

Syncing across Macs: commit here, `make update` there. History, dotfiles, themes, and the AI tools all follow.

---

## 15. WM profiles & multi-monitor

**Two window manager profiles, one command each:**

| | `make wm WM=aerospace` (default) | `make wm WM=yabai` |
|---|---|---|
| Engine | AeroSpace (virtual workspaces) | yabai + skhd (native Spaces) |
| Workspaces | 1–5, bar-integrated | macOS Spaces, skhd-bound |
| SIP | not required | partial disable needed for animations + Space control |
| Config | `aerospace/aerospace.toml` | `yabai/yabairc` + `skhd/skhdrc` |
| Keys | `⌥hjkl/arrows`, `⌥⇧R` rebalance | `⌥hjkl`, `⌥⇧hjkl` warp, stacks, mirrors |

Switching quits the other WM — never run both at once. yabai tiles fine
without touching SIP; only its animations and Space manipulation need the
scripting addition (recovery mode: `csrutil disable --partial --with-music`).
That is a personal security trade-off — the default install doesn't touch SIP.

**Prompt profile:** starship is the default. Prefer powerlevel10k (john-json's
look, `.p10k.zsh` vendored in `p10k/`)? Set `ZSH_PROMPT=p10k` in
`~/.zshrc.local` and open a new terminal.

**The tiling setup is multi-monitor aware:** workspaces 1–3 live on the main
display, 4–5 on the secondary (edit the `workspace-to-monitor-force-assignment`
table in `aerospace.toml`). The floating bar renders on every display; the
notch pill and Dynamic Island stay on the notched one. `⌥⇧⇥` throws a whole
workspace to the other monitor.

**Lid closed, external monitor (clamshell mode)** — macOS does this natively,
with three requirements:

1. **Power connected** — on battery the Mac sleeps when the lid closes
2. **External display connected** (HDMI/USB-C)
3. Any external keyboard + mouse

Then just close the lid. If it still sleeps:

```sh
sudo pmset -a disablesleep 1    # never sleep, even lid-closed on battery
# undo (recommended when travelling — battery + heat):
sudo pmset -a disablesleep 0
```

**One rule for AeroSpace multi-monitor:** keep "Displays have separate Spaces"
OFF (System Settings → Desktop & Dock) — `macos/defaults.sh` already enforces
it. Separate Spaces breaks AeroSpace focus and workspace placement in fun and
creative ways.

## 16. Troubleshooting

**The tiling setup is multi-monitor aware:** workspaces 1–3 live on the main
display, 4–5 on the secondary (edit the `workspace-to-monitor-force-assignment`
table in `aerospace.toml`). The floating bar renders on every display; the
notch pill and Dynamic Island stay on the notched one. `⌥⇧⇥` throws a whole
workspace to the other monitor.

**Lid closed, external monitor (clamshell mode)** — macOS does this natively,
with three requirements:

1. **Power connected** — on battery the Mac sleeps when the lid closes
2. **External display connected** (HDMI/USB-C)
3. Any external keyboard + mouse

Then just close the lid. If it still sleeps:

```sh
sudo pmset -a disablesleep 1    # never sleep, even lid-closed on battery
# undo (recommended when travelling — battery + heat):
sudo pmset -a disablesleep 0
```

**One rule for AeroSpace multi-monitor:** keep "Displays have separate Spaces"
OFF (System Settings → Desktop & Dock) — `macos/defaults.sh` already enforces
it. Separate Spaces breaks AeroSpace focus and workspace placement in fun and
creative ways.

## 16. Troubleshooting

**A window won't tile** — it's floating or fullscreen. `alt-t` to tile it, `alt-f` to leave fullscreen. Some apps float better (accessibility quirks); add an `on-window-detected` rule to float them permanently.

**SketchyBar looks wrong / stale** — `brew services restart sketchybar`. Errors land in `/opt/homebrew/var/log/sketchybar/sketchybar.err.log` (real errors only — your Lua config prints there).

**Workspaces in the bar are blank** — the bar started before AeroSpace. Restart the bar (`brew services restart sketchybar`); it re-queries on startup and on every `aerospace_change` event.

**Karabiner keys don't work** — Accessibility permission for Karabiner-Elements in System Settings, then restart the app. Needs the logout after first install.

**Menu bar came back after a macOS update** — `macos/defaults.sh` sets `_HIHideMenuBar`; run `make defaults`, or toggle System Settings → Control Center → Automatically hide menu bar.

**A brew install wants sudo** (Karabiner does this) — run it yourself in a terminal; the repo's scripts never assume a password.

**tmux plugins missing** — inside tmux: `ctrl-space` + `I`. TPM clones into `~/.config/tmux/plugins/` (gitignored).

**Something's deeply wrong** — `./install.sh` again. It converges. Worst case: `make clean` (unlinks everything), then `make install`.

---

## 17. Uninstalling

```sh
make clean          # removes every symlink; the repo keeps all configs
brew services stop sketchybar borders
brew bundle --file=(brew --repository)/… # or selectively: brew uninstall <pkg>
```

The repo itself is disposable and restorable — it's one `git clone` away. Apps installed via casks can be removed with `brew uninstall --cask <name>` if you ever want the Mac vanilla again. Everything it replaced during setup is still in `~/dotfiles-backup-*`.

---

## 19. Credits

This system stands on tall shoulders:

- **[Ryoku](https://github.com/Ryoku-dev/ryoku)** — the paper-and-ink design language, the discipline, the 力 seal
- **[FelixKratz/SketchyBar](https://github.com/FelixKratz/SketchyBar)** + his dotfiles — the Lua bar architecture (GPL-3.0, see `LICENSE-NOTE.md`)
- **[AeroSpace](https://github.com/nikitabobko/AeroSpace)** · **[Ghostty](https://ghostty.org)** · **[starship](https://starship.rs)** · **[atuin](https://atuin.sh)** · **[Catppuccin](https://github.com/catppuccin/catppuccin)** · **[Tokyo Night](https://github.com/folke/tokyonight.nvim)** · **[tpm](https://github.com/tmux-plugins/tpm)** — the well-starred machinery
- **[opencode](https://opencode.ai)** · **[pi](https://pi.dev)** — the agents
- **[ChrisTitusTech](https://github.com/ChrisTitusTech)** — the kill-the-animations defaults philosophy
- **[Omarchy](https://omarchy.org)** — the idea that a computer manual can have a voice

*This manual, like the system, is a file in the repo. Improve it with a commit.*
