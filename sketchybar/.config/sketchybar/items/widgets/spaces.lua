-- AeroSpace-driven workspace dots — visuals vendored from john-json/dotfiles
-- (colored dots, smooth transitions, hover expansion), state from AeroSpace.
local colors = require("colors")
local settings = require("settings")

local spaces = {}
local space_items = {}

local WORKSPACE_COUNT = 5 -- keep in sync with aerospace.toml

-- Per-workspace identity colors (john-json style)
local space_colors = {
  colors.red,
  colors.orange,
  colors.yellow,
  colors.magenta,
  colors.blue,
}

-- Smooth color transition (his smoothColorTransition)
local function smoothColorTransition(space, targetColor)
  sbar.animate("sin", 15, function(progress)
    local r1, g1, b1 = sbar.colorComponents(space.background.color)
    local r2, g2, b2 = sbar.colorComponents(targetColor)
    space:set({
      background = {
        color = sbar.colorFromComponents(
          r1 + (r2 - r1) * progress,
          g1 + (g2 - g1) * progress,
          b1 + (b2 - b1) * progress
        ),
      },
    })
  end)
end

-- Currently focused AeroSpace workspace (number) or nil
local function focused_workspace()
  local ok, handle = pcall(io.popen, "aerospace list-workspaces --focused 2>/dev/null")
  if not ok or handle == nil then return nil end
  local out = handle:read("*a") or ""
  handle:close()
  return out:match("^(%d+)")
end

local function update(focused)
  for i = 1, WORKSPACE_COUNT do
    local selected = (focused == tostring(i))
    local targetColor = selected and space_colors[i] or colors.primary
    smoothColorTransition(spaces[i], targetColor)
    sbar.animate("elastic", 10, function()
      spaces[i]:set({
        label = {
          padding_left = selected and 10 or 2,
          padding_right = selected and 10 or 2,
        },
      })
    end)
  end
end

for i = 1, WORKSPACE_COUNT do
  local space = sbar.add("item", "space." .. i, {
    position = "center",
    width = 0,
    background = {
      color = colors.primary,
      height = 12,
      corner_radius = 2,
      padding_left = 2,
      padding_right = 2,
      drawing = true,
      position = "center",
      align = "center",
    },
  })
  spaces[i] = space
  table.insert(space_items, space.name)

  space:subscribe("mouse.clicked", function()
    sbar.exec("aerospace workspace " .. i .. " 2>/dev/null")
  end)

  space:subscribe("mouse.entered", function()
    sbar.animate("elastic", 10, function()
      space:set({
        background = { padding_left = 8, padding_right = 8 },
      })
    end)
  end)

  space:subscribe("mouse.exited", function()
    sbar.animate("elastic", 10, function()
      space:set({
        background = { padding_left = 2, padding_right = 2 },
      })
    end)
  end)
end

local spaces_bracket = sbar.add("bracket", "spaces.bracket", space_items, {
  display = 1,
  width = "dynamic",
})

-- Hidden observer: AeroSpace fires aerospace_change on workspace switches
local observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

observer:subscribe("aerospace_change", function(_)
  update(focused_workspace())
end)

-- Initial state
update(focused_workspace())

return spaces_bracket
