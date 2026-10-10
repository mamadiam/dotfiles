-- carbon — muted dark scheme inspired by john-json/dotfiles colors_dark
-- (charcoal surfaces, warm yellow accent, desaturated data colors)
-- Tokens file: this is the one place the bar's look is defined.
return {
  black = 0xff111111,
  white = 0xffcdcdcd,
  red = 0xffc6755b,
  green = 0xff98a8a9,
  blue = 0xffa2aab9,
  yellow = 0xffdcaf6c,
  orange = 0xffd09367,
  magenta = 0xff6a6378,
  grey = 0xff5a5959,
  transparent = 0x00000000,

  accent = 0xffdcaf6c,
  sun = 0xffdcaf6c,

  bar = {
    bg = 0xf0181818, -- solid charcoal, floats 4px below the top edge
    border = 0xff232323,
  },
  popup = {
    bg = 0xf0202020,
    border = 0xff333333,
  },
  bg1 = 0xff202020,
  bg2 = 0xff2a2a2a,
  line = 0xff2a2a2a,

  radius = 6,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
