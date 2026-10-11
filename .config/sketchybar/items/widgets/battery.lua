local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Battery: percent + state, styled for the carbon theme (hasnarobert idea,
-- rebuilt natively for this bar's Lua pills). Polls pmset; power_source_change
-- gives instant feedback on plug/unplug.

local battery = sbar.add("item", "widgets.battery", {
    display = 1,
    position = "right",
    icon = {
        string = icons.battery._100,
        font = { style = settings.font.style_map["Regular"], size = 14 },
        color = colors.white,
        padding_left = settings.paddings,
    },
    label = {
        string = "100%",
        font = { family = settings.font.numbers, style = settings.font.style_map["Regular"], size = 12 },
        color = colors.white,
        padding_right = settings.paddings,
    },
    update_freq = 120,
})

local function update()
    sbar.exec("pmset -g batt", function(out)
        local percent = tonumber(out:match("(%d+)%%"))
        if not percent then return end
        local charging = out:find("AC Power") ~= nil

        local icon = icons.battery._100
        if percent < 25 then
            icon = icons.battery._0
        elseif percent < 50 then
            icon = icons.battery._50
        elseif percent < 75 then
            icon = icons.battery._75
        end
        if charging then icon = icons.battery.charging end

        local color = colors.white
        if percent <= 20 and not charging then
            color = colors.red
        end

        battery:set({
            icon = {
                string = icon,
                color = charging and colors.yellow or color,
            },
            label = { string = percent .. "%" },
        })
    end)
end

battery:subscribe({ "routine", "system_woke", "power_source_change" }, update)
update()

-- spacing consistent with the other right-side widgets
sbar.add("item", { position = "right", width = settings.group_paddings })

return battery
