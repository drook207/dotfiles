-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Example: output can be found with hyprctl monitors. Edit variables.lua for the monitor outputs instead of here directly
-- hl.monitor({
--     output    = MONITOR1,
--     mode      = "1920x1080@60",
--     position  = "0x0",
--     scale     = "1",
-- })

hl.monitor({
    output    = MONITOR1,
    mode      = "preferred",
    position  = "auto",
    scale     = "auto",
})

-- Built-in laptop panel: always 1x. The configs are tuned for a 1920x1080
-- desktop, but "auto" switches to 1.5x above 140 PPI, which smaller 1080p
-- panels (e.g. 14"/12.5" ThinkPads) exceed, shrinking the desktop to 1280x720.
hl.monitor({
    output    = "eDP-1",
    mode      = "preferred",
    position  = "auto",
    scale     = "1",
})
