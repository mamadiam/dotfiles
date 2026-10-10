-- Compact wifi indicator (adapted for this repo — GPL-3.0 lineage)
local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local wifi = sbar.add("item", "widgets.wifi", {
  position = "right",
  icon = {
    string = icons.wifi.disconnected,
    color = colors.grey,
    font = {
      style = settings.font.style_map["Regular"],
      size = 14.0,
    },
  },
  label = {
    color = colors.white,
    padding_right = 8,
    font = { size = 12.0 },
  },
  padding_left = 8,
  updates = true,
})



sbar.add("item", "widgets.wifi.padding", {
  position = "right",
  width = settings.group_paddings
})

local function refresh()
  local ok, handle = pcall(io.popen, "networksetup -getairportnetwork en0 2>/dev/null")
  if not ok or handle == nil then return end
  local out = handle:read("*a") or ""
  handle:close()
  local ssid = out:match("Current Wi%-Fi Network: (%S+)")
  wifi:set({
    icon = {
      string = ssid and icons.wifi.connected or icons.wifi.disconnected,
      color = ssid and colors.white or colors.grey,
    },
    label = { drawing = ssid ~= nil, string = ssid or "" },
  })
end

wifi:subscribe("wifi_change", refresh)
wifi:subscribe("mouse.clicked", function()
  sbar.exec("open /System/Library/PreferencePanes/Network.prefPane")
end)

refresh()
