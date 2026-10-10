-- tokyo-night — the sexy one. Deep translucent indigo, neon purple accent,
-- vivid data colors. Palette: Tokyo Night (folke/tokyonight.nvim, Apache-2.0).
-- Tokens file: this is the one place the bar's look is defined.
return {
  black = 0xff16161e,
  white = 0xffc0caf5,
  red = 0xfff7768e,
  green = 0xff9ece6a,
  blue = 0xff7aa2f7,
  yellow = 0xffe0af68,
  orange = 0xffff9e64,
  magenta = 0xffbb9af7, -- purple
  grey = 0xff565f89, -- comment
  transparent = 0x00000000,

  -- the accent: neon purple, lives on the frame
  accent = 0xffbb9af7,
  sun = 0xffbb9af7,

  bar = {
    bg = 0x00000000, -- invisible
    border = 0xff1a1b26,
  },
  popup = {
    bg = 0xe9292e42,
    border = 0xff565f89,
  },
  bg1 = 0xff292e42, -- bg_highlight
  bg2 = 0xff2f334d,
  line = 0xff2f334d,

  -- geometry token — rounder pills for the night look
  radius = 9,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
