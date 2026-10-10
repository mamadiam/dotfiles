-- The 力 seal — the one brand mark on the bar, in vermillion.
-- (力 = power. Ryoku pairs kanji seals with Latin labels; so do we.)
local colors = require("colors")
local settings = require("settings")

sbar.add("item", "seal", {
  position = "left",
  icon = {
    string = "力",
    font = { family = settings.font.jp, size = 13.0 },
    color = colors.sun,
    padding_left = 12,
    padding_right = 2,
  },
  label = { drawing = false },
  width = 0,
})
