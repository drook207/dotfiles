-- Look and feel configuration

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 8,
        border_size = 2,
        extend_border_grab_area = 10,
        resize_on_border = true,
        col = {
            active_border = {
                colors = { KANAGAWA_YELLOW, KANAGAWA_VIOLET },
                angle = 45,
            },
            inactive_border = KANAGAWA_GRAY,
        },
    },
    group = {
        col = {
            border_active = KANAGAWA_AQUA,
            border_inactive = KANAGAWA_GRAY,
            border_locked_active = KANAGAWA_RED,
            border_locked_inactive = KANAGAWA_GRAY,
        },
        groupbar = {
            col = {
                active = KANAGAWA_YELLOW,
                inactive = KANAGAWA_GRAY,
                locked_active = KANAGAWA_RED,
                locked_inactive = KANAGAWA_GRAY,
            },
        },
    },
    decoration = {
        dim_special = 0.3,
        rounding = 10,
        active_opacity = 0.95,
        inactive_opacity = 0.85,
        fullscreen_opacity = 1,
        blur = {
            size = 5,
            passes = 4,
            special = true,
        },
    },
})
