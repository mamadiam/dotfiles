-- AeroSpace-native workspaces item.
-- Rewritten for this dotfiles repo: FelixKratz's original queries yabai;
-- this version reads AeroSpace workspaces instead. (Structure kept, GPL-3.0.)
local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

-- Keep in sync with aerospace.toml workspace mappings
local WORKSPACE_COUNT = 5

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
    spaces[i]:set({
      icon = { highlight = selected },
      label = { highlight = selected, string = icon_line_for(i) },
      background = {
        color = selected and colors.bg2 or colors.bg1,
        corner_radius = 13,
        border_width = selected and 1 or 0,
        border_color = selected and colors.accent or colors.bg2,
      },
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
      highlight_color = colors.accent,
    },
    label = {
      padding_right = 12,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_left = 1,
    padding_right = 1,
    background = {
      color = colors.bg1,
      corner_radius = 13,
      border_width = 0,
      height = 26,
      border_color = colors.bg2,
    },
  })
  spaces[i] = space

  -- Pill look: per-space plates, no outer bracket
  sbar.add("bracket", { space.name }, {
    background = { drawing = false }
  })

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
