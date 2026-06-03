-- Hyprland 0.55 Lua Configuration
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

hl.config({
    render = {
        direct_scanout = false,
    },
    cursor = {
        no_hardware_cursors = true,
    },
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local menu     = "hyprlauncher"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hyprlauncher -d")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("sh ~/.config/hypr/hyprpaper.sh")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd(terminal)
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in          = 1,
        gaps_out         = 1,

        border_size      = 1,

        col              = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 3,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow           = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur             = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Animations
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("straight", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "straight" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "straight", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "straight" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 3, bezier = "straight" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "straight" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "straight" })

-- Dwindle layout
-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
hl.config({
    dwindle = {
        -- NOTE: dwindle:pseudotile has been removed in 0.55
        preserve_split = true,
    },
})

-- Master layout
-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
hl.config({
    master = {
        new_status = "master",
    },
})

---------------
---- INPUT ----
---------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
    input = {
        kb_layout     = "fr",
        kb_variant    = "",
        kb_model      = "",
        kb_options    = "ctrl:nocaps",
        kb_rules      = "",

        follow_mouse  = 1,
        mouse_refocus = false,
        sensitivity   = 0,  -- -1.0 to 1.0, 0 means no modification

        touchpad      = {
            natural_scroll = false,
        },
    },
})

-- Per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- XWayland
hl.config({
    xwayland = {
        enabled            = true,
        force_zero_scaling = true,
    },
})

---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

-- dwindle
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.layout("togglesplit"))

-- Move focus (vim-style: h/j/k/l)
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))

-- Switch workspaces with mainMod + [AZERTY keys]
-- French AZERTY layout workspace keys
local workspace_keys = {
    "Ampersand", "Eacute", "Quotedbl", "Apostrophe", "Parenleft",
    "Minus", "Egrave", "Underscore", "Ccedilla", "Agrave"
}
for i, key in ipairs(workspace_keys) do
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Screenshot: select region, save and open in swappy
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(
    'grim -g "$(slurp)" ~/Pictures/Screenshots/$(TZ=utc date +\'screenshot_%Y-%m-%d-%H%M%S.%3N.png\') | swappy -f -'
))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------------
---- WORKSPACE → MONITOR    ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
local workspace_monitor_map = {
    [1]  = "DP-3",
    [2]  = "HDMI-A-1",
    [3]  = "DP-3",
    [4]  = "HDMI-A-1",
    [5]  = "DP-3",
    [6]  = "HDMI-A-1",
    [7]  = "DP-3",
    [8]  = "HDMI-A-1",
    [9]  = "DP-3",
    [10] = "HDMI-A-1",
    [11] = "DP-3",
    [12] = "HDMI-A-1",
}
for ws, mon in pairs(workspace_monitor_map) do
    hl.workspace_rule({ workspace = tostring(ws), monitor = mon })
end

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Ignore maximize requests from all apps
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Unreal Editor rules
hl.window_rule({
    name     = "unreal-no-initial-focus",
    match    = { class = "^(UnrealEditor)$", title = "^()$" },
    no_focus = true,
})

hl.window_rule({
    name  = "unreal-save-float",
    match = { class = "^(UnrealEditor)$", title = "^(Save)(.*)$" },
    float = true,
})

hl.window_rule({
    name  = "unreal-import-float",
    match = { class = "^(UnrealEditor)$", title = "^(Import)(.*)$" },
    float = true,
})

hl.window_rule({
    name    = "unreal-no-anim",
    match   = { class = "^(UnrealEditor)$" },
    no_anim = true,
})
