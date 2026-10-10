# License notes

## sketchybar/ package

The Lua configuration in `sketchybar/.config/sketchybar/` is adapted from
[FelixKratz/dotfiles](https://github.com/FelixKratz/dotfiles), which is
licensed under **GPL-3.0**.

- **Verbatim or lightly modified files** (carry a `-- Vendored from` header):
  `init.lua`, `bar.lua`, `default.lua`, `icons.lua`, `helpers/app_icons.lua`,
  `items/calendar.lua`, `items/media.lua`, `items/battery.lua`,
  `items/volume.lua`, `items/front_app.lua`
- **Original rewrites** (same architecture, new code):
  `colors.lua` (Catppuccin Mocha palette),
  `items/spaces.lua` (AeroSpace instead of yabai),
  `items/wifi.lua` (simplified),
  `helpers/init.lua` (no C helper build)
- `settings.lua` and `sketchybarrc` are his, trimmed.

Consequence: if you distribute this repository (or a system built from it),
the `sketchybar/` directory must remain under GPL-3.0 with attribution.
Personal use is unaffected.

Also vendored at install time (not committed here):
- [SbarLua](https://github.com/FelixKratz/SbarLua) (GPL-3.0, built from a pinned commit)
- [sketchybar-app-font](https://github.com/kvndrsslr/sketchybar-app-font) (OFL, pinned v2.0.28)

## sumi theme (paper and ink)

The `sumi` theme's design language — the "warm bone on pure black" palette,
contrast tiers, hairline/inversion rules, type roles, and the 力 mark — is
adapted from the design system of [Ryoku](https://github.com/Ryoku-dev/ryoku)
(GPL-3.0), as documented in their `docs/ui-ux.md` and `Tokens.qml`.

No Ryoku code is included: every themed file here was written for macOS apps
(ghostty, sketchybar, tmux, starship, yazi, bat, btop, borders, Übersicht).
Color values and design metrics are unprotectable facts, but attribution is
given in the spirit of the license. The Ryoku name and logo are theirs; the 力
glyph is a common kanji used as a mark, not their logotype.

Type system: Fraunces, Space Grotesk, SpaceMono (SIL OFL), Noto Sans CJK JP (OFL).
