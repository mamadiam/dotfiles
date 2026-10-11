-- colors_dark.lua — TokyoNight Night (tcmmichaelb139-inspired setup)
return {
    yellow = 0xffe0af68,
    green = 0xff9ece6a,
    red = 0xfff7768e,
    blue = 0xff7aa2f7,
    darkblue = 0xff3d59a1,
    purple = 0xff9d7cd8,
    monotone = 0xffa9b1d6,
    orange = 0xffff9e64,
    quicksilver = 0xffa9b1d6,
    pink = 0xffcf91b5,
    magenta = 0xffbb9af7,

    primary = 0xff7aa2f7,
    secondary = 0xff24283b,

    black = 0xff000000,
    white = 0xffa9b1d6,
    grey = 0xff565f89,

    transparent = 0x00000000,
    semi_transparent = 0x40ffffff,
    border_transparent = 0x33ffffff,

    icon = {
        grey = 0xffa9b1d6,
        primary = 0xff7aa2f7,
        secondary = 0xff16161e,
    },
    bar = {
        bg = 0xff1a1b26,
        bg2 = 0xff24283b,
        bg_transparent = 0x991a1b26,
        accent = 0xff7aa2f7,
        active = 0xff7dcfff,
        selected = 0xff292e42,
        transparent = 0xe51a1b26,
        border = 0xff2f334d,
        secondary = 0xff292e42,
        white_transparent = 0x0dffffff,
        inactive = 0xff16161e,
        icons = 0xff565f89,
        foreground = 0xffc0caf5,
        foreground_hover = 0xff7dcfff,
    },
    media = {
        primary = 0xcc1a1b26,
        secondary = 0xffffffff,
    },
    popup = {
        text = 0xffc0caf5,
        bg = 0xe61a1b26,
        bg_alt = 0xff24283b,
        icons = 0xff737aa2,
        border = 0xff2f334d,
        buttons = 0xffa9b1d6,
        blur_radius = 60,
        with_alpha = function(color, alpha)
            if alpha > 1.0 or alpha < 0.0 then return color end
            return (color and 0x001a1b26) or (math.floor(alpha * 255.0) < 24)
        end
    }
}
