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

-- The notch cover: the hardware notch can't be drawn over, so we give it a
-- black tab in the bar's center — the notch disappears into it (works on
-- every theme; on external displays it reads as a deliberate black segment).
sbar.add("item", "notch_cover", {
  position = "center",
  width = 240,
  background = { color = colors.black },
  drawing = true,
})
