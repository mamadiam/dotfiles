-- Vendored from FelixKratz/dotfiles (GPL-3.0) — see LICENSE-NOTE.md
-- https://github.com/FelixKratz/dotfiles/tree/master/.config/sketchybar

local colors = require("colors")

-- Equivalent to the --bar domain
-- Floating bar (john-json style): inset from the top edge, rounded,
-- shadowed, solid dark backdrop. Widgets keep their own plates on top.
sbar.bar({
  height = 30,
  y_offset = 4,
  corner_radius = 6,
  shadow = true,
  blur_radius = 40,
  border_width = 0,
  color = colors.bar.bg,
  padding_right = 8,
  padding_left = 8,
})

sbar.bar({ alpha = 1 })

