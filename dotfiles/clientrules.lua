
-- Theme
local beautiful = require("beautiful")
beautiful.init(os.getenv("AWESOME_THEME") or "~/.config/awesome/theme.lua")

-- Awful
local awful = require("awful")

-- keybinds
local keys = require("keybinds")

local M = {
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
return M
