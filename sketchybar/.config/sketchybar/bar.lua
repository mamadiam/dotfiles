-- Vendored from FelixKratz/dotfiles (GPL-3.0) — see LICENSE-NOTE.md
-- https://github.com/FelixKratz/dotfiles/tree/master/.config/sketchybar

local colors = require("colors")

-- Equivalent to the --bar domain
-- Floating invisible bar: items float 4px below the top edge; only
-- widgets/spaces carry their own pill plates. (john-json style inset)
sbar.bar({
  height = 30,
  y_offset = 4,
  corner_radius = 6,
  shadow = false,
  border_width = 0,
  color = colors.transparent,
  padding_right = 8,
  padding_left = 8,
})

sbar.bar({ alpha = 1 })

