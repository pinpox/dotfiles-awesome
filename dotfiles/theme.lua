-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
---------------------------------------------
-- Awesome theme which follows xrdb config --
--   by Yauhen Kirylau                    --
---------------------------------------------

local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

-- inherit default theme
local theme = dofile(themes_path.."default/theme.lua")
-- load vector assets' generators for this theme

theme.font_family = "Berkeley Mono"
theme.font_size = "9"
theme.font =  theme.font_family .. " " .. theme.font_size

local palette = {}

palette.Black        = xrdb.color0
palette.BrightBlack  = xrdb.color8

palette.Red          = xrdb.color1
palette.BrightRed    = xrdb.color9

palette.Green        = xrdb.color2
palette.BrightGreen  = xrdb.color10

palette.Yellow       = xrdb.color3
palette.BrightYellow = xrdb.color11

palette.Blue         = xrdb.color4
palette.BrightBlue   = xrdb.color12

palette.Magenta      = xrdb.color5
palette.BrightMagenta = xrdb.color13

palette.Cyan         = xrdb.color6
palette.BrightCyan   = xrdb.color14

palette.White        = xrdb.color7
palette.BrightWhite  = xrdb.color15


theme.bg_normal     = palette.Black
theme.bg_focus      = palette.Blue
theme.bg_urgent     = palette.Red
theme.bg_minimize   = palette.Black
theme.bg_systray    = palette.Black

theme.fg_normal     = palette.White
theme.fg_focus      = palette.Black
theme.fg_urgent     = palette.Red
theme.fg_minimize   = palette.Green

theme.useless_gap   = dpi(3)
theme.border_width  = dpi(2)
theme.border_normal = palette.BrightBlack
theme.border_focus  = palette.Blue
theme.border_marked = palette.Green

-- Taglist (workspace indicator)
theme.taglist_fg_focus = palette.Black
theme.taglist_bg_focus = palette.Blue
theme.taglist_fg_urgent = palette.Black
theme.taglist_bg_urgent = palette.Red
theme.taglist_fg_occupied = palette.White
theme.taglist_bg_occupied = palette.BrightBlack
-- theme.taglist_fg_empty
-- theme.taglist_bg_empty
-- theme.taglist_fg_volatile
-- theme.taglist_bg_volatile

theme.taglist_spacing = 5
-- theme.taglist_shape = gears.shape.rounded_rect
--


-- Tasklist (windows on workspace)
theme.tasklist_fg_focus = palette.Black
theme.tasklist_bg_focus = palette.Blue
theme.tasklist_fg_urgent = palette.Black
theme.tasklist_bg_urgent = palette.Red

-- Titlebar (window decorations)
theme.titlebar_fg_normal = palette.White
theme.titlebar_bg_normal = palette.BrightBlack
theme.titlebar_fg_focus = palette.Black
theme.titlebar_bg_focus = palette.Blue
--
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
-- theme.taglist_bg_focus = "#ff0000"

theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal


-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(16)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.fg_normal)

-- Recolor titlebar icons:
--
local function darker(color_value, darker_n)
    local result = "#"
    for s in color_value:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
        local bg_numeric_value = tonumber("0x"..s) - darker_n
        if bg_numeric_value < 0 then bg_numeric_value = 0 end
        if bg_numeric_value > 255 then bg_numeric_value = 255 end
        result = result .. string.format("%2.2x", bg_numeric_value)
    end
    return result
end

theme = theme_assets.recolor_titlebar( theme, palette.BrighRed, "normal")
theme = theme_assets.recolor_titlebar( theme, palette.BrightRed, "normal", "hover")
theme = theme_assets.recolor_titlebar( theme, palette.BrightBlack, "normal", "press")
theme = theme_assets.recolor_titlebar( theme, palette.Black, "focus")
theme = theme_assets.recolor_titlebar( theme, darker(theme.fg_focus, -60), "focus", "hover")
theme = theme_assets.recolor_titlebar( theme, palette.Red, "focus", "press")

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon( theme.menu_height, palette.Red, palette.Green)

-- Generate taglist squares:
theme.taglist_squares_sel = theme_assets.taglist_squares_sel( dpi(5), palette.Red)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel( dpi(5), palette.Green)

-- Notifications
local naughty = require("naughty")
local nconf = naughty.config

nconf.defaults.border_width = dpi(2)
nconf.defaults.margin = 16

nconf.defaults.shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,6) end
nconf.defaults.text = "Boo!"
nconf.defaults.position = "top_middle"
nconf.defaults.timeout = 10

-- Space between popup and edge of screen/workarea
nconf.padding = dpi(80)

nconf.presets.critical.bg = palette.Red
nconf.presets.critical.fg = palette.Black
nconf.presets.low.bg = palette.BrightBlack
nconf.presets.normal.bg = palette.Black
nconf.defaults.icon_size = 64
nconf.spacing = 8

-- Generate wallpaper:
local cairo = require("lgi").cairo

theme.wallpaper = function(s)
    -- return gen_wallpaper(wallpaper_bg, wallpaper_fg, wallpaper_alt_fg, s)
    s = s or screen.primary
    local height = s.geometry.height
    local width = s.geometry.width
    local img = cairo.RecordingSurface(cairo.Content.COLOR,
    cairo.Rectangle { x = 0, y = 0, width = width, height = height })
    local cr = cairo.Context(img)

    package.path = package.path .. ";/home/pinpox/.local/share/wallpaper-generator/?.lua"
    colors = require "colors"
    generator = require("generators.harmonograph")

   local palette_wpgen =  {}
palette_wpgen.base00 = palette.Black
palette_wpgen.base01 = palette.BrightBlack

palette_wpgen.base02 = palette.BrightBlack
palette_wpgen.base03 = palette.BrightBlack
palette_wpgen.base04 = palette.BrightBlack
palette_wpgen.base05 = palette.White

palette_wpgen.base06 = palette.White
palette_wpgen.base07 = palette.BrightWhite
palette_wpgen.base08 = palette.Red
palette_wpgen.base09 = palette.BrightRed
palette_wpgen.base0A = palette.Yellow
palette_wpgen.base0B = palette.Green
palette_wpgen.base0C = palette.Cyan
palette_wpgen.base0D = palette.Blue
palette_wpgen.base0E = palette.Magenta
palette_wpgen.base0F = palette.BrightYellow

    generator(cr, palette_wpgen, width, height)
    return img
end

-- Generates a button image given a base color using cairo. The output image
-- will be a filled circle with darker shade outline of the same color
function button_image(fg)
    local size = dpi(24)

    -- Create new image and fill it with transparency
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, size, size)
    local cr = cairo.Context(img)
    cr:set_source(gears.color.transparent)
    cr:paint()

    -- Draw circle and fill it. cr:circle() is throwing errors, so just use the
    -- arc() function with a complete rotation instead
    cr:new_sub_path()
    cr:arc(size/2, size/2, size/3, 0, 2 * math.pi)
    cr:close_path()
    cr:set_source(gears.color(fg))

    -- Use the _preserve variant of the fill() function, this prevents the
    -- path from being discarted after filling so we can use it to draw the
    -- outer line below
    cr:fill_preserve()

    -- Draw outer line, in a darker shade
    cr:set_source(gears.color(darker(fg, 60)))
    cr:set_line_width(dpi(1));
    cr:stroke()

    return img
end

-- Generates normal, dark and light shade of buttons for a given base color.
function button_variants(fg)
    return button_image(fg), button_image(darker(fg, 30)), button_image(darker(fg, -30))
end

-- Cache the buttons in variables, so we don't have to generate them multiple
-- times as drawing them is expensive
local button_images = {}
button_images.red, button_images.red_dark, button_images.red_light = button_variants(xrdb.color1)
button_images.yellow, button_images.yellow_dark, button_images.yellow_light = button_variants(xrdb.color3)
button_images.green, button_images.green_dark, button_images.green_light = button_variants(xrdb.color2)
button_images.blue, button_images.blue_dark, button_images.blue_light = button_variants(xrdb.color4)
button_images.grey, button_images.grey_dark, button_images.grey_light = button_variants(xrdb.color8)

-- Association between colors and button types
local button_types = {
    ["close"] = "red",
    ["sticky"] = "yellow",
    ["floating"] = "green"
}

-- Association between button states and color shades
-- This could be further reduced with another loop over "", "_active" and
-- "_inactive" but in the future, there might be diffent behaviours for these
-- classes, so I'll list them sepraterly to be able to assign individual values
-- if needed later.
local button_actions = {
    [""] = "",
    ["_hover"] = "_light",
    ["_press"] = "_dark",
    ["_active"] = "_dark",
    ["_active_hover"] = "_light",
    ["_active_press"] = "_dark",
    ["_inactive"] = "",
    ["_inactive_hover"] = "_light",
    ["_inactive_press"] = "_dark"
}

-- Set the icons. Some unused icons are set, e.g. a not-focused window can't be
-- hovered since it would become focused, but the code is a lot cleaner this way
-- and the additional images will have very little performance impact.
for button_type, button_color in pairs(button_types) do
    for i, window_state in ipairs({"normal", "focus"}) do
        for button_action, color_shade in pairs(button_actions) do
            theme["titlebar_" .. button_type .. "_button_" .. window_state .. button_action] = button_images[button_color .. color_shade]
        end
    end
end

return theme
