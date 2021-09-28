local awful = require("awful")
local gears = require("gears")
-- Theme handling library
local beautiful = require("beautiful")

-- Themes define colours, icons, font and wallpapers. The environment variable
-- provides an option to override the default, e.g. when running in xephyr
beautiful.init(os.getenv("AWESOME_THEME") or "~/.config/awesome/theme.lua")

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
