-- sumi — paper and ink. Warm bone on pure black, vermillion on the frame.
-- Tokens file: this is the one place the bar's look is defined.
-- Design language adapted from Ryoku (ryoku.dev); palette from their Tokens.
return {
  black = 0xff000000, -- paper
  white = 0xffcdc4ba, -- ink (titles/values)
  red = 0xffe2342a, -- the alert — always the alert
  green = 0xff9daa84,
  blue = 0xff7f9dbe,
  yellow = 0xffd8a657,
  orange = 0xffe0876a,
  magenta = 0xffc39ac3,
  grey = 0xff7a756e, -- inkFaint
  transparent = 0x00000000,

  -- the accent: lives on the frame, never on content
  accent = 0xffe2342a, -- vermillion
  sun = 0xffe2342a,

  bar = {
    bg = 0xe6000000, -- paper, mostly opaque
    border = 0xff000000,
  },
  popup = {
    bg = 0xf00a0a0a, -- paperLift
    border = 0xff353330, -- hairline: ink at 26%
  },
  bg1 = 0xff0a0a0a, -- paperLift
  bg2 = 0xff1a1817, -- lifted surface border
  line = 0xff353330,

  -- geometry token (Ryoku: "a hair of rounding", radius 6)
  radius = 6,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
