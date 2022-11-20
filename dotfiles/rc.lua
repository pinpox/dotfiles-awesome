-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Initialize random seed
math.randomseed(os.time())

-- Global variables
Modkey = "Mod4" -- Default modkey (super/win-key)
Terminal = "wezterm"
Editor = os.getenv("EDITOR") or "nvim"
EditorCmd = Terminal .. " -e " .. Editor

-- Standard awesome library
local awful = require("awful")

-- Table of layouts to cover with awful.layout.inc, order matters.
require("awful.autofocus")

awful.layout.layouts = {
    awful.layout.suit.max,
    awful.layout.suit.tile,
}

-- Tags
require("tags")

-- Mainmenu shown on right-click
require("mainmenu")

-- Set keybindings
local keys = require("keybinds")
root.keys(keys.global)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = require("clientrules")

-- Error notifications
require("errors")

-- Ui elements
require("ui")

-- Generate and set wallpaper
require("wallpaper")

-- Signals for clients (windows)
local clientsignals = require("clientsignals")
for signal, fun in pairs(clientsignals ) do
    client.connect_signal(signal, fun)
end


require("signals")





-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
