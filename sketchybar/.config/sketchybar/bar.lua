-- Vendored from FelixKratz/dotfiles (GPL-3.0) — see LICENSE-NOTE.md
-- https://github.com/FelixKratz/dotfiles/tree/master/.config/sketchybar

local colors = require("colors")

-- Equivalent to the --bar domain
-- Invisible bar: the items float directly on the desktop.
sbar.bar({
  height = 30,
  corner_radius = 0,
  shadow = false,
  border_width = 0,
  border_color = colors.transparent,
  color = colors.transparent,
  padding_right = 8,
  padding_left = 8,
})


sbar.bar({ alpha = 1 })

