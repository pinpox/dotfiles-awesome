-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local menubar = require("menubar")

-- Widgets from https://github.com/streetturtle/awesome-wm-widgets/
-- local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
-- local volumearc_widget = require("awesome-wm-widgets.volumearc-widget.volumearc")
-- local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
-- local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
-- local storage_widget = require("awesome-wm-widgets.fs-widget.fs-widget")


-- local inspect = require("inspect")
-- {{{ Local extensions
sharedtags = require("awesome-sharedtags")
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/theme.lua")

-- Add a gap around clients
beautiful.useless_gap  = 5

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.max,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}
function filelog(text)
    file = io.open("awesomelog", "a")
    io.output(file)
    io.write(text, "\n")
    io.close(file)
end

-- {{{ Tags
tags = sharedtags({
    { name = "1", screen = 1, layout = awful.layout.layouts[1] },
    { name = "2", screen = 2, layout = awful.layout.layouts[1] },
    { name = "3", screen = 3, layout = awful.layout.layouts[1] },
    { name = "4", screen = 1, layout = awful.layout.layouts[1] },
    { name = "5", screen = 1, layout = awful.layout.layouts[1] },
    { name = "6", screen = 1, layout = awful.layout.layouts[1] },
    { name = "7", screen = 1, layout = awful.layout.layouts[1] },
    { name = "8", screen = 1, layout = awful.layout.layouts[1] },
    { name = "9", screen = 1, layout = awful.layout.layouts[1] },
    { name = "0", screen = 1, layout = awful.layout.layouts[1] },
    -- { layout = awful.layout.layouts[2] },
    -- { screen = 2, layout = awful.layout.layouts[2] }
})
-- }}}

-- {{{ Menu
-- Create the main menu
dofile("/home/pinpox/.config/awesome/mainmenu.lua")
dofile("/home/pinpox/.config/awesome/keybinds.lua")
dofile("/home/pinpox/.config/awesome/rules.lua")
dofile("/home/pinpox/.config/awesome/errors.lua")

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%H:%M")


-- local cw = calendar_widget({
--     theme = 'nord',
--     placement = 'top_right',
-- })
-- mytextclock:connect_signal("button::press",
--     function(_, _, _, button)
--         if button == 1 then cw.toggle() end
--     end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
awful.button({ }, 1, function(t) t:view_only() end),
awful.button({ modkey }, 1, function(t)
    if client.focus then
        client.focus:move_to_tag(t)
    end
end),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, function(t)
    if client.focus then
        client.focus:toggle_tag(t)
    end
end),
awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
awful.button({ }, 1, function (c)
    if c == client.focus then
        c.minimized = true
    else
        c:emit_signal(
        "request::activate",
        "tasklist",
        {raise = true}
        )
    end
end),
awful.button({ }, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
end),
awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
end),
awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
end))

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

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Assign tags to the newly connected screen here,
    -- if desired:
    --sharedtags.viewonly(tags[4], s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        -- filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        s.mytaglist,
        s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
    layout = wibox.layout.fixed.horizontal,
    mykeyboardlayout,
    -- cpu_widget({
    --     width = 70,
    --     step_width = 2,
    --     step_spacing = 0,
    --     color = '#434c5e'
    -- }),
    -- volumearc_widget({
    --     main_color = '#af13f7',
    --     mute_color = '#ff0000',
    --     thickness = 5,
    --     height = 25,
    -- }),
    -- storage_widget(), --default


    -- batteryarc_widget({
    -- show_current_level = true,
    -- }),
    wibox.widget.systray(),
    mytextclock,
    s.mylayoutbox,
},
    }
end)
-- }}}

-- Set keys
root.keys(globalkeys)
-- }}}



-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
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

    awful.titlebar(c) : setup {
        { -- Left
        awful.titlebar.widget.iconwidget(c),
        buttons = buttons,
        layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
    { -- Title
    align  = "center",
    widget = awful.titlebar.widget.titlewidget(c)
},
buttons = buttons,
layout  = wibox.layout.flex.horizontal
        },
        { -- Right
        awful.titlebar.widget.floatingbutton (c),
        awful.titlebar.widget.maximizedbutton(c),
        awful.titlebar.widget.stickybutton   (c),
        awful.titlebar.widget.ontopbutton    (c),
        awful.titlebar.widget.closebutton    (c),
        layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
}
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
--
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
