-- Vendored from FelixKratz/dotfiles (GPL-3.0) — see LICENSE-NOTE.md
-- https://github.com/FelixKratz/dotfiles/tree/master/.config/sketchybar

local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  height = 34,
  color = colors.bar.bg,
  padding_right = 2,
  padding_left = 2,
})
