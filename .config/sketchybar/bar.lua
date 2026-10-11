local colors = require("colors")
local sbar = require("sketchybar")

-- Floating TokyoNight bar (tcmmichaelb139 geometry): visible translucent
-- strip, radius 15, blur; widgets render directly on it (pills keep their
-- own bg2 plates). This replaces the old invisible-bar design.
sbar.bar({
    position = "top",
    height = 30,
    drawing = true,
    y_offset = 5,
    margin = 5,
    padding_right = 5,
    padding_left = 5,
    color = colors.bar.bg_transparent,
    corner_radius = 15,
    border_width = 1,
    border_color = colors.bar.border,
    shadow = false,
    blur_radius = 20,
})

sbar.bar({ alpha = 1 })
