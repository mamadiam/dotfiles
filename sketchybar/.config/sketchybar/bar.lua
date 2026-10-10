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

-- The notch pill: a black rounded tab around the hardware notch —
-- the circle. Pure config, zero flaky third-party processes.
sbar.add("item", "notch_pill", {
  position = "center",
  width = 240,
  background = { color = colors.black, corner_radius = 12 },
  drawing = true,
})

-- quiet fade-in on reload
sbar.animate("sin", 15, function()
  sbar.bar({ alpha = 0 })
  sbar.animate("sin", 15, function()
    sbar.bar({ alpha = 1 })
  end)
end)

