-- AeroSpace-driven workspaces with john-json's colored-space identity:
-- every workspace owns a color; the active one transitions smoothly to full
-- brightness, inactive ones rest dimmed. (Query logic ours, aesthetics his.)
local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

-- Keep in sync with aerospace.toml workspace mappings
local WORKSPACE_COUNT = 5

-- Per-workspace identity colors (john-json style)
local space_colors = {
  colors.red, -- 1
  colors.orange, -- 2
  colors.yellow, -- 3
  colors.magenta, -- 4
  colors.blue, -- 5
}

local function dim(c) return colors.with_alpha(c, 0.30) end

-- Smooth color transition (john-json's smoothColorTransition)
local function smoothTransition(space, target)
  sbar.animate("sin", 15, function(progress)
    local r1, g1, b1 = sbar.colorComponents(space.background.color)
    local r2, g2, b2 = sbar.colorComponents(target)
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

-- Returns the app-icon string for all windows in a workspace
local function icon_line_for(ws)
  local ok, handle = pcall(io.popen,
    "aerospace list-windows --workspace " .. ws .. " --format '%{app-name}' 2>/dev/null")
  if not ok or handle == nil then return "—" end
  local line = ""
  for app in handle:lines() do
    if app ~= "" then
      line = line .. (app_icons[app] or app_icons["Default"])
    end
  end
  handle:close()
  if line == "" then return "—" end
  return line
end

-- Currently focused AeroSpace workspace (number) or nil
local function focused_workspace()
  local ok, handle = pcall(io.popen, "aerospace list-workspaces --focused 2>/dev/null")
  if not ok or handle == nil then return nil end
  local out = handle:read("*a") or ""
  handle:close()
  local ws = out:match("^(%d+)")
  return ws
end

local function update(focused)
  for i = 1, WORKSPACE_COUNT do
    local selected = (focused == tostring(i))
    local target = selected and space_colors[i] or dim(space_colors[i])
    smoothTransition(spaces[i], target)
    spaces[i]:set({
      icon = { color = selected and colors.black or colors.white },
      label = { color = selected and colors.black or colors.white, string = icon_line_for(i) },
    })
  end
end

for i = 1, WORKSPACE_COUNT do
  local space = sbar.add("item", "space." .. i, {
    icon = {
      font = { family = settings.font.numbers },
      string = i,
      padding_left = 15,
      padding_right = 8,
      color = colors.white,
    },
    label = {
      padding_right = 12,
      color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_left = 1,
    padding_right = 1,
    background = {
      color = dim(space_colors[i]),
      corner_radius = colors.radius,
      height = 26,
    },
  })
  spaces[i] = space

  -- Padding between workspace items
  sbar.add("item", "space.padding." .. i, {
    width = settings.group_paddings,
  })

  space:subscribe("mouse.clicked", function()
    sbar.exec("aerospace workspace " .. i .. " 2>/dev/null")
  end)
end

-- Hidden observer: reacts to the custom aerospace_change event.
-- aerospace.toml fires it via:
--   exec-on-workspace-change = ['/bin/bash', '-c', 'sketchybar --trigger aerospace_change']
-- We don't trust the trigger's env handoff into Lua — ask AeroSpace directly.
local observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

observer:subscribe("aerospace_change", function(_)
  update(focused_workspace())
end)

-- Initial state (aerospace may not be running yet — then highlight nothing)
update(focused_workspace())
