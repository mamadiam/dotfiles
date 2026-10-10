-- Vendored from FelixKratz/dotfiles (GPL-3.0) — see LICENSE-NOTE.md
-- https://github.com/FelixKratz/dotfiles/tree/master/.config/sketchybar

local colors = require("colors")

-- Equivalent to the --bar domain
-- Flat bar: solid strip, full screen width, flush with the top edge.
sbar.bar({
  height = 30,
  corner_radius = 0,
  shadow = false,
  color = colors.bar.bg,
  padding_right = 8,
  padding_left = 8,
})

-- quiet fade-in on reload
sbar.animate("sin", 15, function()
  sbar.bar({ alpha = 0 })
  sbar.animate("sin", 15, function()
    sbar.bar({ alpha = 1 })
  end)
end)

