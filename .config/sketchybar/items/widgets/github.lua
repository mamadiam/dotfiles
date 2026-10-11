local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- GitHub notifications bell — polls `gh` every 3 minutes, lists unread in a
-- popup, opens the inbox on click. Ported from omerxx/dotfiles (whose bell
-- pointed at a script he never committed); rebuilt for this bar's Lua pills.

local POLL_SECONDS = 180
local MAX_SLOTS = 8
local INBOX_URL = "https://github.com/notifications"

local github = sbar.add("item", "widgets.github", {
    display = 1,
    position = "right",
    icon = {
        string = icons.bell,
        font = { style = settings.font.style_map["Semibold"], size = 14 },
        color = colors.grey,
        padding_left = settings.paddings,
    },
    label = {
        drawing = false,
        string = "",
        font = { family = settings.font.numbers, style = settings.font.style_map["Bold"], size = 11 },
        color = colors.blue,
        padding_right = settings.paddings,
    },
    update_freq = POLL_SECONDS,
    popup = { align = "right" },
})

-- Popup rows: header + notification slots + footer (created in display order)
local header = sbar.add("item", {
    position = "popup." .. github.name,
    width = 320,
    icon = {
        string = icons.bell,
        color = colors.blue,
        font = { style = settings.font.style_map["Bold"], size = 13 },
        padding_left = 8,
    },
    label = {
        string = "GitHub · unread",
        font = { style = settings.font.style_map["Bold"], size = 12 },
        color = colors.white,
    },
    background = { color = colors.transparent },
})

local slots = {}
for i = 1, MAX_SLOTS do
    slots[i] = sbar.add("item", {
        position = "popup." .. github.name,
        width = 320,
        drawing = false,
        icon = {
            string = "·",
            color = colors.grey,
            font = { style = settings.font.style_map["Bold"], size = 12 },
            padding_left = 12,
        },
        label = {
            string = "",
            max_chars = 44,
            font = { family = settings.font.text, style = settings.font.style_map["Regular"], size = 11 },
            color = colors.white,
            padding_right = 8,
        },
        background = { color = colors.transparent },
    })
    slots[i]:subscribe("mouse.clicked", function()
        sbar.exec("open " .. INBOX_URL)
        github:set({ popup = { drawing = false } })
    end)
end

local footer = sbar.add("item", {
    position = "popup." .. github.name,
    width = 320,
    icon = {
        string = "↗",
        color = colors.blue,
        font = { style = settings.font.style_map["Bold"], size = 12 },
        padding_left = 12,
    },
    label = {
        string = "open inbox",
        font = { style = settings.font.style_map["Regular"], size = 11 },
        color = colors.white,
    },
    background = { color = colors.transparent },
})
footer:subscribe("mouse.clicked", function()
    sbar.exec("open " .. INBOX_URL)
    github:set({ popup = { drawing = false } })
end)

-- Unread count: dim bell when zero or when `gh` is unavailable/unauthenticated
local function update_count()
    sbar.exec("gh api notifications --jq 'length' 2>/dev/null", function(count)
        local n = tonumber(tostring(count):match("%d+")) or 0
        if n > 0 then
            github:set({
                icon = { color = colors.blue },
                label = { drawing = true, string = tostring(n) },
            })
        else
            github:set({
                icon = { color = colors.grey },
                label = { drawing = false },
            })
        end
    end)
end

local function fill_popup()
    sbar.exec(
        "gh api notifications --jq '.[] | .repository.full_name + \" · \" + .subject.title' | head -"
            .. MAX_SLOTS,
        function(out)
            local i = 1
            for line in tostring(out):gmatch("[^\r\n]+") do
                if slots[i] then
                    slots[i]:set({ drawing = true, label = { string = line } })
                    i = i + 1
                end
            end
            for j = i, MAX_SLOTS do
                slots[j]:set({ drawing = false })
            end
        end)
end

github:subscribe("mouse.clicked", function()
    if github:query().popup.drawing == "off" then
        fill_popup()
        github:set({ popup = { drawing = true } })
    else
        github:set({ popup = { drawing = false } })
    end
end)

github:subscribe("mouse.exited.global", function()
    sbar.delay(0.4, function()
        github:set({ popup = { drawing = false } })
    end)
end)

github:subscribe({ "routine", "system_woke" }, update_count)
update_count()

-- spacing consistent with the other right-side widgets
sbar.add("item", { position = "right", width = settings.group_paddings })

return github
