-- catppuccin mocha — the alternate palette (switch: scripts/theme.sh catppuccin)
-- Tokens file: this is the one place the bar's look is defined.
return {
  black = 0xff11111b, -- crust
  white = 0xffcdd6f4, -- text
  red = 0xfff38ba8,
  green = 0xffa6e3a1,
  blue = 0xff89b4fa,
  yellow = 0xfff9e2af,
  orange = 0xfffab387, -- peach
  magenta = 0xffcba6f7, -- mauve
  grey = 0xff6c7086, -- overlay0
  transparent = 0x00000000,

  accent = 0xffcba6f7, -- mauve
  sun = 0xffcba6f7,

  bar = {
    bg = 0x00000000, -- invisible
    border = 0xff1e1e2e,
  },
  popup = {
    bg = 0xc01e1e2e,
    border = 0xff585b70, -- surface2
  },
  bg1 = 0xff313244, -- surface0
  bg2 = 0xff45475a, -- surface1
  line = 0xff585b70,

  radius = 9,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
