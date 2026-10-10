local colors = require("colors")
local sbar = require("sketchybar")

-- Invisible floating bar: items float 4px below the top edge; only their
-- own plates (space dots, widget pills) are visible. Nothing else may
-- write to the bar domain — there is no bar-style switcher anymore.
sbar.bar({
    position = "top",
    height = 30,
    y_offset = 4,
    padding_right = 5,
    padding_left = 5,
    color = colors.transparent,
    border_width = 0,
    shadow = false,
    blur_radius = 0,
})

sbar.bar({ alpha = 1 })
