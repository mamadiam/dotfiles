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
-- Color state: direct set (his animated transition relied on SbarLua
-- property reads this build doesn't expose)
local function setColor(space, targetColor)
  space:set({ background = { color = targetColor } })
end

-- Currently focused AeroSpace workspace (number) or nil
local function focused_workspace()
  local ok, handle = pcall(io.popen, "/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null")
  if not ok or handle == nil then return nil end
  local out = handle:read("*a") or ""
  handle:close()
  return out:match("^(%d+)")
end

local function update(focused)
  local f = io.open("/tmp/dots.log", "a")
  for i = 1, WORKSPACE_COUNT do
    local selected = (focused == tostring(i))
    local targetColor = selected and space_colors[i] or colors.primary
    setColor(spaces[i], targetColor)
    spaces[i]:set({
      label = {
        padding_left = selected and 10 or 2,
        padding_right = selected and 10 or 2,
      },
    })
  end
end

for i = 1, WORKSPACE_COUNT do
  local space = sbar.add("item", "space." .. i, {
    position = "center",
    background = {
      color = colors.primary,
      height = 12,
      corner_radius = 2,
      padding_left = 7,
      padding_right = 7,
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
        background = { padding_left = 10, padding_right = 10 },
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
