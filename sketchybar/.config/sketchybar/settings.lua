return {
  paddings = 3,
  group_paddings = 5,

  icons = "NerdFont", -- alternatively available: sf-symbols (needs SF fonts)

  -- JetBrainsMono Nerd Font is installed via the Brewfile
  font = {
    text = "JetBrainsMono Nerd Font", -- Used for text
    numbers = "JetBrainsMono Nerd Font", -- Used for numbers
    jp = "Noto Sans CJK JP", -- Used for kanji seals
    style_map = {
      ["Regular"] = "Regular",
      ["Semibold"] = "Medium",
      ["Bold"] = "SemiBold",
      ["Heavy"] = "Bold",
      ["Black"] = "ExtraBold",
    },
  },
}
