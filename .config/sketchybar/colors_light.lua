-- colors_light.lua — TokyoNight Day (tcmmichaelb139-inspired setup)
return {
    yellow = 0xff8c6c3e,
    green = 0xff587539,
    red = 0xfff52a65,
    blue = 0xff2e7de9,
    darkblue = 0xff2e7de9,
    purple = 0xff9854f1,
    monotone = 0xff6172b0,
    orange = 0xffb15c00,
    quicksilver = 0xff6172b0,
    pink = 0xffd20069,
    magenta = 0xff9854f1,

    primary = 0xff2e7de9,
    secondary = 0xffc4c8da,

    black = 0xff000000,
    white = 0xff3760bf,
    grey = 0xff848cb5,

    transparent = 0x00000000,
    semi_transparent = 0x403760bf,
    border_transparent = 0x333760bf,

    icon = {
        grey = 0xff6172b0,
        primary = 0xff2e7de9,
        secondary = 0xffe1e2e7,
    },
    bar = {
        bg = 0xffe1e2e7,
        bg2 = 0xffc4c8da,
        bg_transparent = 0x99e1e2e7,
        accent = 0xff2e7de9,
        active = 0xff007197,
        selected = 0xffb6bfe1,
        transparent = 0xe5e1e2e7,
        border = 0xffa8aec2,
        secondary = 0xffd0d5e3,
        white_transparent = 0x0d3760bf,
        inactive = 0xffe9e9ed,
        icons = 0xff848cb5,
        foreground = 0xff3760bf,
        foreground_hover = 0xff007197,
    },
    media = {
        primary = 0xcce1e2e7,
        secondary = 0xff3760bf,
    },
    popup = {
        text = 0xff3760bf,
        bg = 0xe6e1e2e7,
        bg_alt = 0xffc4c8da,
        icons = 0xff848cb5,
        border = 0xffa8aec2,
        buttons = 0xff6172b0,
        blur_radius = 60,
        with_alpha = function(color, alpha)
            if alpha > 1.0 or alpha < 0.0 then return color end
            return (color and 0x00e1e2e7) or (math.floor(alpha * 255.0) < 24)
        end
    }
}
