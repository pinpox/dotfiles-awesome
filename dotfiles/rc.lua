-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

math.randomseed(os.time())

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Themes define colours, icons, font and wallpapers. The environment variable
-- provides an option to override the default, e.g. when running in xephyr
beautiful.init(os.getenv("AWESOME_THEME") or "~/.config/awesome/theme.lua")


-- Add a gap around clients
beautiful.useless_gap  = 5

-- This is used later as the default terminal and editor to run.
Terminal = "wezterm"
Editor = os.getenv("EDITOR") or "nvim"
EditorCmd = Terminal .. " -e " .. Editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
Modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.max,
    awful.layout.suit.tile,
}


-- {{{ Tags
local tags = require("tags")

require("mainmenu")
local keys = require("keybinds")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.client,
            buttons = keys.clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            maximized_vertical   = false,
            maximized_horizontal = false,
            floating = false,
            maximized = false
        }
    },

    {
        rule = { floating = true },
        properties = {ontop = true}
    },

    {
        rule = { class = "Firefox" },
        properties = {
            opacity = 1,
            maximized = false,
            floating = false
        }
    },

    {
        rule = { class = "Navigator" },
        properties = {
            opacity = 1,
            maximized = false,
            floating = false
        }
    },

    {
        rule = { class = "firefox" },
        properties = {
            opacity = 1,
            maximized = false,
            floating = false
        }
    },

    {
        rule = { class = "navigator" },
        properties = {
            opacity = 1,
            maximized = false,
            floating = false
        }
    },

    {
        -- Floating clients.
        rule_any = {
            instance = { "pinentry", },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "Sxiv",
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },
    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = { "normal", "dialog" }
        }, properties = { titlebars_enabled = true }
    },
}
require("errors")
require("bar")

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Wallpaper on all screens
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Set keys
root.keys(keys.global)

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)

    -- Rounded corners for all clients, 5px radius
    c.shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,5)
    end
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
    awful.button({ }, 1, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.resize(c)
    end)
    )

    -- local titlebar = awful.titlebar(c, {
    --     height = 24
    -- })

    awful.titlebar(c) : setup {
        {
            -- Left
            {
            -- add margin around titlebar icons
                awful.titlebar.widget.iconwidget(c),
                layout = wibox.container.margin,
                top = 5,
                left = 5,
                bottom = 5
            },
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        {
            -- Middle
            {
                -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        {
            -- Right
            {
                awful.titlebar.widget.floatingbutton (c),
                awful.titlebar.widget.stickybutton   (c),
                -- awful.titlebar.widget.ontopbutton    (c),
                awful.titlebar.widget.closebutton    (c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.container.margin,
            top = 3,
            left = 3,
            right = 3,
            bottom = 3
        },
        layout = wibox.layout.align.horizontal
    } end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
