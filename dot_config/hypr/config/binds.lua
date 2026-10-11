-- Keybindings following Omarchy's defaults (basecamp/omarchy v4.0.4,
-- default/hypr/bindings/*.lua), ported to CachyOS + Noctalia.
-- Omarchy-specific scripts are replaced by Noctalia IPC or plain commands;
-- bindings whose only implementation is an omarchy-* script are left out.

local noctCall = "noctalia msg "
local launchPrefix = "uwsm app -- " -- if you are not using UWSM, make this empty (e.g. "")

-- Every binding made through bind(), for the keybindings menu (SUPER+K)
local bindList = {}

-- bind(keys, description, action, opts)
-- action: a dispatcher, a Lua function, or a shell command string (launched via UWSM)
local function bind(keys, description, action, opts)
    opts = opts or {}
    opts.description = description
    table.insert(bindList, { keys = keys, description = description })
    if type(action) == "string" then
        action = hl.dsp.exec_cmd(launchPrefix .. action)
    end
    return hl.bind(keys, action, opts)
end

local function noct(cmd)
    return hl.dsp.exec_cmd(noctCall .. cmd)
end

local function webapp(url)
    return BROWSER .. " --new-window " .. url
end

-- Bind by physical keycode so the number row works on any layout.
-- Digit d -> evdev keycode: 1..9 => 10..18, 0 => 19
local function digitCode(d)
    return "code:" .. (d == 0 and 19 or (9 + d))
end

---------------------
---- APPLICATIONS ----
---------------------

bind("SUPER + RETURN",               "Terminal",          TERMINAL)
bind("SUPER + CTRL + RETURN",        "Herdr",             TERMINAL .. " -e herdr")
bind("SUPER + SHIFT + RETURN",       "Browser",           BROWSER)
bind("SUPER + SHIFT + B",            "Browser",           BROWSER)
bind("SUPER + SHIFT + ALT + B",      "Browser (private)", BROWSER .. " --private-window")
bind("SUPER + SHIFT + F",            "File manager",      FILE_MANAGER)
bind("SUPER + SHIFT + N",            "Editor",            EDITOR)
bind("SUPER + SHIFT + SLASH",        "Passwords",         "1password")
-- Docker isn't reachable without sudo on purpose (docker group = root), like Omarchy
bind("SUPER + SHIFT + D",            "Docker",            TERMINAL .. " -e sudo lazydocker")

bind("SUPER + SHIFT + A",            "ChatGPT",           webapp("https://chatgpt.com"))
bind("SUPER + SHIFT + ALT + A",      "Grok",              webapp("https://grok.com"))
bind("SUPER + SHIFT + C",            "Calendar",          webapp("https://app.hey.com/calendar/weeks/"))
bind("SUPER + SHIFT + E",            "Email",             webapp("https://app.hey.com"))
bind("SUPER + SHIFT + Y",            "YouTube",           webapp("https://youtube.com/"))
bind("SUPER + SHIFT + ALT + G",      "WhatsApp",          webapp("https://web.whatsapp.com/"))
bind("SUPER + SHIFT + CTRL + G",     "Google Messages",   webapp("https://messages.google.com/web/conversations"))
bind("SUPER + SHIFT + P",            "Google Photos",     webapp("https://photos.google.com/"))
bind("SUPER + SHIFT + S",            "Google Maps",       webapp("https://maps.google.com/"))
bind("SUPER + SHIFT + X",            "X",                 webapp("https://x.com/"))
bind("SUPER + SHIFT + ALT + X",      "X Post",            webapp("https://x.com/compose/post"))

----------------
---- TILING ----
----------------

bind("SUPER + W",        "Close window",                  hl.dsp.window.close())
bind("SUPER + J",        "Toggle window split",           hl.dsp.layout("togglesplit"))
bind("SUPER + P",        "Pseudo window",                 hl.dsp.window.pseudo())
bind("SUPER + T",        "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
bind("SUPER + F",        "Full screen",                   hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind("SUPER + ALT + F",  "Full width",                    hl.dsp.window.fullscreen({ mode = "maximized" }))
bind("SUPER + O",        "Pop window out (float & pin)",  function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.pin())
end)

bind("SUPER + LEFT",  "Focus on left window",  hl.dsp.focus({ direction = "l" }))
bind("SUPER + RIGHT", "Focus on right window", hl.dsp.focus({ direction = "r" }))
bind("SUPER + UP",    "Focus on above window", hl.dsp.focus({ direction = "u" }))
bind("SUPER + DOWN",  "Focus on below window", hl.dsp.focus({ direction = "d" }))

for workspace = 1, 10 do
    local key = digitCode(workspace % 10)
    bind("SUPER + " .. key,               "Switch to workspace " .. workspace,         hl.dsp.focus({ workspace = tostring(workspace) }))
    bind("SUPER + SHIFT + " .. key,       "Move window to workspace " .. workspace,    hl.dsp.window.move({ workspace = tostring(workspace) }))
    bind("SUPER + SHIFT + ALT + " .. key, "Move window silently to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace), follow = false }))
end

bind("SUPER + S",       "Toggle scratchpad",         hl.dsp.workspace.toggle_special("scratchpad"))
bind("SUPER + ALT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

bind("SUPER + TAB",          "Next workspace",     hl.dsp.focus({ workspace = "e+1" }))
bind("SUPER + SHIFT + TAB",  "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
bind("SUPER + CTRL + TAB",   "Former workspace",   hl.dsp.focus({ workspace = "previous" }))

bind("SUPER + SHIFT + ALT + LEFT",  "Move workspace to left monitor",  hl.dsp.workspace.move({ monitor = "l" }))
bind("SUPER + SHIFT + ALT + RIGHT", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))
bind("SUPER + SHIFT + ALT + UP",    "Move workspace to up monitor",    hl.dsp.workspace.move({ monitor = "u" }))
bind("SUPER + SHIFT + ALT + DOWN",  "Move workspace to down monitor",  hl.dsp.workspace.move({ monitor = "d" }))

bind("SUPER + SHIFT + LEFT",  "Swap window to the left",  hl.dsp.window.swap({ direction = "l" }))
bind("SUPER + SHIFT + RIGHT", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
bind("SUPER + SHIFT + UP",    "Swap window up",           hl.dsp.window.swap({ direction = "u" }))
bind("SUPER + SHIFT + DOWN",  "Swap window down",         hl.dsp.window.swap({ direction = "d" }))

bind("ALT + TAB",         "Focus on next window",        hl.dsp.window.cycle_next())
bind("ALT + SHIFT + TAB", "Focus on previous window",    hl.dsp.window.cycle_next({ next = false }))
bind("ALT + TAB",         "Reveal active window on top", hl.dsp.window.bring_to_top())
bind("ALT + SHIFT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())

bind("CTRL + ALT + TAB",         "Focus on next monitor",     hl.dsp.focus({ monitor = "+1" }))
bind("CTRL + ALT + SHIFT + TAB", "Focus on previous monitor", hl.dsp.focus({ monitor = "-1" }))

-- code:20 / code:21 are the two keys right of the number row (- and = on US)
bind("SUPER + code:20",         "Expand window left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
bind("SUPER + code:21",         "Shrink window left", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
bind("SUPER + SHIFT + code:20", "Shrink window up",   hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
bind("SUPER + SHIFT + code:21", "Expand window down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

bind("SUPER + ALT + code:20",         "Expand window left a little", hl.dsp.window.resize({ x = -25, y = 0, relative = true }))
bind("SUPER + ALT + code:21",         "Shrink window left a little", hl.dsp.window.resize({ x = 25, y = 0, relative = true }))
bind("SUPER + SHIFT + ALT + code:20", "Shrink window up a little",   hl.dsp.window.resize({ x = 0, y = -25, relative = true }))
bind("SUPER + SHIFT + ALT + code:21", "Expand window down a little", hl.dsp.window.resize({ x = 0, y = 25, relative = true }))

bind("SUPER + CTRL + code:20",         "Expand window left a lot", hl.dsp.window.resize({ x = -300, y = 0, relative = true }))
bind("SUPER + CTRL + code:21",         "Shrink window left a lot", hl.dsp.window.resize({ x = 300, y = 0, relative = true }))
bind("SUPER + CTRL + SHIFT + code:20", "Shrink window up a lot",   hl.dsp.window.resize({ x = 0, y = -300, relative = true }))
bind("SUPER + CTRL + SHIFT + code:21", "Expand window down a lot", hl.dsp.window.resize({ x = 0, y = 300, relative = true }))

bind("SUPER + mouse_down", "Scroll active workspace forward",  hl.dsp.focus({ workspace = "e+1" }))
bind("SUPER + mouse_up",   "Scroll active workspace backward", hl.dsp.focus({ workspace = "e-1" }))

bind("SUPER + mouse:272", "Move window",   hl.dsp.window.drag())
bind("SUPER + mouse:273", "Resize window", hl.dsp.window.resize())

bind("SUPER + G",       "Toggle window grouping",         hl.dsp.group.toggle())
bind("SUPER + ALT + G", "Move active window out of group", hl.dsp.window.move({ out_of_group = true }))

bind("SUPER + ALT + LEFT",  "Move window to group on left",   hl.dsp.window.move({ into_group = "l" }))
bind("SUPER + ALT + RIGHT", "Move window to group on right",  hl.dsp.window.move({ into_group = "r" }))
bind("SUPER + ALT + UP",    "Move window to group on top",    hl.dsp.window.move({ into_group = "u" }))
bind("SUPER + ALT + DOWN",  "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))

bind("SUPER + ALT + TAB",         "Next window in group",           hl.dsp.group.next())
bind("SUPER + ALT + SHIFT + TAB", "Previous window in group",       hl.dsp.group.prev())
bind("SUPER + CTRL + LEFT",       "Move grouped window focus left",  hl.dsp.group.prev())
bind("SUPER + CTRL + RIGHT",      "Move grouped window focus right", hl.dsp.group.next())
bind("SUPER + ALT + mouse_down",  "Next window in group",           hl.dsp.group.next())
bind("SUPER + ALT + mouse_up",    "Previous window in group",       hl.dsp.group.prev())

for index = 1, 5 do
    bind("SUPER + ALT + " .. digitCode(index), "Switch to group window " .. index, hl.dsp.group.active({ index = index }))
end

-------------------
---- UTILITIES ----
-------------------

-- Menus (Omarchy menu -> Noctalia launcher/session panels)
bind("SUPER + SPACE",          "Launcher",    noct("panel-toggle launcher"))
bind("SUPER + ALT + SPACE",    "Apps menu",   noct("panel-toggle launcher"))
bind("SUPER + CTRL + E",       "Emojis",      noct("panel-toggle launcher /emo"))
bind("SUPER + ESCAPE",         "System menu", noct("panel-toggle session"))
bind("XF86PowerOff",           "Power menu",  noct("panel-toggle session"), { locked = true })
bind("SUPER + CTRL + Q",       "Calculator",  CALCULATOR)
bind("XF86Calculator",         "Calculator",  CALCULATOR)

bind("SUPER + K",                    "Keybindings",          TERMINAL .. " --class=dev.drook.keybindings -e hypr-keybindings")
bind("SUPER + SHIFT + SPACE",        "Toggle top bar",       noct("bar-toggle"))
bind("SUPER + CTRL + SPACE",         "Background switcher",  noct("panel-toggle wallpaper"))
bind("SUPER + SHIFT + CTRL + SPACE", "Theme / settings",     noct("settings-toggle"))

-- Notifications
bind("SUPER + comma",               "Dismiss notifications",          noct("notification-clear-active"))
bind("SUPER + SHIFT + comma",       "Dismiss all notifications",      noct("notification-clear-active"))
bind("SUPER + CTRL + comma",        "Toggle silencing notifications", noct("notification-dnd-toggle"))
bind("SUPER + ALT + comma",         "Invoke last notification",       noct("notification-invoke-latest"))
bind("SUPER + SHIFT + ALT + comma", "Open notification history",      noct("panel-toggle control-center notifications"))

bind("SUPER + CTRL + I", "Toggle locking on idle", noct("caffeine-toggle"))
bind("SUPER + CTRL + N", "Toggle nightlight",      noct("nightlight-force-toggle"))

-- Capture
bind("PRINT",         "Screenshot",   noct("screenshot-region"))
bind("ALT + PRINT",          "Screen recording (start/stop)", "screenrecord")
bind("SUPER + PRINT",        "Color picker", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"))
bind("SUPER + CTRL + PRINT", "Extract text (OCR) from screenshot", "screenshot-ocr")

-- Control center panels
bind("SUPER + CTRL + A",       "Audio",     noct("panel-toggle control-center audio"))
bind("SUPER + CTRL + B",       "Bluetooth", noct("panel-toggle control-center bluetooth"))
bind("SUPER + CTRL + ALT + D", "Calendar",  noct("panel-toggle control-center calendar"))
bind("SUPER + CTRL + W",       "Network",   noct("panel-toggle control-center network"))
bind("SUPER + CTRL + P",       "Power",     noct("panel-toggle control-center power"))
bind("SUPER + CTRL + T",       "Activity",  TERMINAL .. " -e btop")

-- Zoom
bind("SUPER + CTRL + Z", "Zoom in", function()
    local zoom = hl.get_config("cursor:zoom_factor") or 1
    hl.config({ cursor = { zoom_factor = zoom + 1 } })
end)
bind("SUPER + CTRL + ALT + Z", "Reset zoom", function()
    hl.config({ cursor = { zoom_factor = 1 } })
end)

bind("SUPER + CTRL + L", "Lock system", noct("session lock"))

---------------
---- MEDIA ----
---------------

bind("XF86AudioRaiseVolume",          "Volume up",                 noct("volume-up"),                 { locked = true, repeating = true })
bind("XF86AudioLowerVolume",          "Volume down",               noct("volume-down"),               { locked = true, repeating = true })
bind("XF86AudioMute",                 "Mute",                      noct("volume-mute"),               { locked = true })
bind("XF86AudioMicMute",              "Mute microphone",           noct("mic-mute"),                  { locked = true })
bind("XF86MonBrightnessUp",           "Brightness up",             noct("brightness-up"),             { locked = true, repeating = true })
bind("XF86MonBrightnessDown",         "Brightness down",           noct("brightness-down"),           { locked = true, repeating = true })
bind("SHIFT + XF86MonBrightnessUp",   "Brightness maximum",        noct("brightness-set 100"),        { locked = true })
bind("SHIFT + XF86MonBrightnessDown", "Brightness minimum",        noct("brightness-set 1"),          { locked = true })
bind("XF86KbdBrightnessUp",           "Keyboard brightness up",    noct("keyboard-backlight-up"),     { locked = true, repeating = true })
bind("XF86KbdBrightnessDown",         "Keyboard brightness down",  noct("keyboard-backlight-down"),   { locked = true, repeating = true })
bind("XF86KbdLightOnOff",             "Keyboard backlight toggle", noct("keyboard-backlight-toggle"), { locked = true })

bind("XF86AudioNext",                "Next track",     noct("media next"),     { locked = true })
bind("ALT + XF86AudioPlay",          "Next track",     noct("media next"),     { locked = true })
bind("XF86AudioPause",               "Pause",          noct("media toggle"),   { locked = true })
bind("XF86AudioPlay",                "Play",           noct("media toggle"),   { locked = true })
bind("XF86AudioPrev",                "Previous track", noct("media previous"), { locked = true })
bind("ALT + SHIFT + XF86AudioPlay",  "Previous track", noct("media previous"), { locked = true })
bind("XF86Eject",                    "Eject media",    hl.dsp.exec_cmd("eject"), { locked = true })

-------------------
---- CLIPBOARD ----
-------------------

-- Universal copy/paste: send Ctrl+C/V to normal windows and the terminal
-- equivalents (Ctrl/Shift+Insert) to terminals. The down/up split works around
-- send_shortcut sometimes leaving synthetic key state stuck.
local terminalClasses = {
    kitty = true, ["com.mitchellh.ghostty"] = true, Alacritty = true,
    ["org.kde.konsole"] = true, foot = true,
}

local function send_shortcut_once(mods, key)
    return function()
        hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
        hl.timer(function()
            hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
        end, { timeout = 50, type = "oneshot" })
    end
end

local function universal_clipboard_shortcut(default_mods, default_key, terminal_mods, terminal_key)
    return function()
        local window = hl.get_active_window()
        if window and terminalClasses[window.class] then
            send_shortcut_once(terminal_mods, terminal_key)()
        else
            send_shortcut_once(default_mods, default_key)()
        end
    end
end

bind("SUPER + C",        "Universal copy",    universal_clipboard_shortcut("CTRL", "C", "CTRL", "Insert"))
bind("SUPER + V",        "Universal paste",   universal_clipboard_shortcut("CTRL", "V", "SHIFT", "Insert"))
bind("SUPER + X",        "Universal cut",     send_shortcut_once("CTRL", "X"))
bind("SUPER + CTRL + V", "Clipboard manager", noct("panel-toggle clipboard"))

-----------------------------
---- KEYBINDINGS MENU DATA ----
-----------------------------

-- Write "keys<TAB>description" for every binding to $XDG_RUNTIME_DIR, where
-- ~/.local/bin/hypr-keybindings reads it. hyprctl can't show keycode bindings
-- (code:N) by name, so they're translated here (US layout labels).
local keyNames = {
    ["code:10"] = "1", ["code:11"] = "2", ["code:12"] = "3", ["code:13"] = "4", ["code:14"] = "5",
    ["code:15"] = "6", ["code:16"] = "7", ["code:17"] = "8", ["code:18"] = "9", ["code:19"] = "0",
    ["code:20"] = "-", ["code:21"] = "=", ["code:34"] = "[", ["code:35"] = "]",
    ["mouse:272"] = "Left click", ["mouse:273"] = "Right click",
    mouse_up = "Scroll up", mouse_down = "Scroll down",
}

pcall(function()
    local dir = os.getenv("XDG_RUNTIME_DIR")
    if not dir then return end
    local file = io.open(dir .. "/hypr-keybindings.tsv", "w")
    if not file then return end
    for _, b in ipairs(bindList) do
        if b.description then
            local keys = b.keys:gsub("[%w_:]+", function(k) return keyNames[k] or k end)
            file:write(keys, "\t", b.description, "\n")
        end
    end
    file:close()
end)
