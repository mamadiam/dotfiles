-- Vendored from FelixKratz/dotfiles (GPL-3.0) — see LICENSE-NOTE.md
-- https://github.com/FelixKratz/dotfiles/tree/master/.config/sketchybar

local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = { drawing = false },
  label = {
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
  },
  updates = true,
  background = { color = colors.bg1, corner_radius = 13, height = 26, drawing = true },
  padding_left = 10,
  padding_right = 10,
})

front_app:subscribe("front_app_switched", function(env)
  front_app:set({ label = { string = string.upper(env.INFO) } })
end)

