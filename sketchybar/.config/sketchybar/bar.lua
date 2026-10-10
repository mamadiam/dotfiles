-- Vendored from FelixKratz/dotfiles (GPL-3.0) — see LICENSE-NOTE.md
-- https://github.com/FelixKratz/dotfiles/tree/master/.config/sketchybar

local colors = require("colors")

-- Equivalent to the --bar domain
-- Floating bar (style from john-json/dotfiles): rounded, blurred, shadowed,
-- inset 4px from the top edge, with a drop-in bounce on startup.
sbar.bar({
  height = 30,
  y_offset = 4,
  corner_radius = 6,
  shadow = true,
  blur_radius = 60,
  color = colors.bar.bg,
  padding_right = 8,
  padding_left = 8,
})

sbar.animate("sin", 15, function()
  sbar.bar({ y_offset = -50, alpha = 0 })
  sbar.animate("sin", 15, function()
    sbar.bar({ y_offset = 12 })
    sbar.animate("sin", 15, function()
      sbar.bar({ y_offset = 4, alpha = 1 })
    end)
  end)
end)

