
local M =  {}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
---------------------------------------------
-- Awesome theme which follows xrdb config --
--   by Yauhen Kirylau                    --
---------------------------------------------
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

-- inherit default theme
local theme = dofile(themes_path .. "default/theme.lua")
-- load vector assets' generators for this theme

M.font = "Sauce Code Pro Nerd Font Semibold 9"

palette = {}

palette.base00 = xrdb.color0
palette.base01 = xrdb.color1
palette.base02 = xrdb.color2
palette.base03 = xrdb.color3
palette.base04 = xrdb.color4
palette.base05 = xrdb.color5
palette.base06 = xrdb.color6
palette.base07 = xrdb.color7
palette.base08 = xrdb.color8
palette.base09 = xrdb.color9
palette.base0A = xrdb.color10
palette.base0B = xrdb.color11
palette.base0C = xrdb.color12
palette.base0D = xrdb.color13
palette.base0E = xrdb.color14
palette.base0F = xrdb.color15

M.bg_normal = palette.base00
M.bg_focus = palette.base0D
M.bg_urgent = palette.base09
M.bg_minimize = palette.base09
M.bg_systray = palette.base00

M.fg_normal = palette.base05
M.fg_focus = palette.base00
M.fg_urgent = palette.base00
M.fg_minimize = palette.base00

M.useless_gap = dpi(3)
M.border_width = dpi(2)
M.border_normal = palette.base03
M.border_focus = palette.base0D
M.border_marked = palette.base0A

-- Taglist (workspace indicator)
M.taglist_fg_focus = palette.base00
M.taglist_bg_focus = palette.base0D
M.taglist_fg_urgent = palette.base00
M.taglist_bg_urgent = palette.base08
M.taglist_fg_occupied = palette.base05
M.taglist_bg_occupied = palette.base03
--M.taglist_fg_empty
--M.taglist_bg_empty
--M.taglist_fg_volatile
--M.taglist_bg_volatile

-- Tasklist (windows on workspace)
M.tasklist_fg_focus = palette.base00
M.tasklist_bg_focus = palette.base0D
M.tasklist_fg_urgent = palette.base00
M.tasklist_bg_urgent = palette.base08

-- Titlebar (window decorations)
M.titlebar_fg_normal = palette.base05
M.titlebar_bg_normal = palette.base00
M.titlebar_fg_focus = palette.base00
M.titlebar_bg_focus = palette.base0D
--
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--M.taglist_bg_focus = "#ff0000"

M.tooltip_fg =M.fg_normal
M.tooltip_bg =M.bg_normal

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
M.menu_submenu_icon = themes_path .. "default/submenu.png"
M.menu_height = dpi(16)
M.menu_width = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--M.bg_widget = "#cc0000"

-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme,M.fg_normal)

-- Recolor titlebar icons:
--
local function darker(color_value, darker_n)
    local result = "#"
    for s in color_value:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
        local bg_numeric_value = tonumber("0x" .. s) - darker_n
        if bg_numeric_value < 0 then bg_numeric_value = 0 end
        if bg_numeric_value > 255 then bg_numeric_value = 255 end
        result = result .. string.format("%2.2x", bg_numeric_value)
    end
    return result
end

theme = theme_assets.recolor_titlebar(theme, palette.base05, "normal")
theme = theme_assets.recolor_titlebar(theme, palette.base03, "normal", "hover")
theme = theme_assets.recolor_titlebar(theme, palette.base01, "normal", "press")
theme = theme_assets.recolor_titlebar(theme, palette.base00, "focus")
theme = theme_assets.recolor_titlebar(theme, darker(M.fg_focus, -60),
                                      "focus", "hover")
theme = theme_assets.recolor_titlebar(theme, palette.base01, "focus", "press")

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
M.icon_theme = nil

-- Generate Awesome icon:
M.awesome_icon = theme_assets.awesome_icon(M.menu_height,
                                               palette.base0E, palette.base00)

-- Generate taglist squares:
M.taglist_squares_sel = theme_assets.taglist_squares_sel(dpi(5),
                                                             palette.base05)
M.taglist_squares_unsel = theme_assets.taglist_squares_unsel(dpi(5),
                                                                 palette.base05)

-- Generate wallpaper:
local cairo = require("lgi").cairo

M.wallpaper = function(s)
    -- return gen_wallpaper(wallpaper_bg, wallpaper_fg, wallpaper_alt_fg, s)
    s = s or screen.primary
    local height = s.geometry.height
    local width = s.geometry.width
    local img = cairo.RecordingSurface(cairo.Content.COLOR, cairo.Rectangle {
        x = 0,
        y = 0,
        width = width,
        height = height
    })
    local cr = cairo.Context(img)

    package.path = package.path ..
                       ";/home/pinpox/.local/share/wallpaper-generator/?.lua"
    colors = require "colors"
    generator = require("generators.harmonograph")
    generator(cr, palette, width, height)
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
    cr:arc(size / 2, size / 2, size / 3, 0, 2 * math.pi)
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
    return button_image(fg), button_image(darker(fg, 30)),
           button_image(darker(fg, -30))
end

-- Cache the buttons in variables, so we don't have to generate them multiple
-- times as drawing them is expensive
local button_images = {}
button_images.red, button_images.red_dark, button_images.red_light =
    button_variants(xrdb.color8)
button_images.yellow, button_images.yellow_dark, button_images.yellow_light =
    button_variants(xrdb.color10)
button_images.green, button_images.green_dark, button_images.green_light =
    button_variants(xrdb.color11)
button_images.blue, button_images.blue_dark, button_images.blue_light =
    button_variants(xrdb.color13)
button_images.grey, button_images.grey_dark, button_images.grey_light =
    button_variants(xrdb.color3)

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
            theme["titlebar_" .. button_type .. "_button_" .. window_state ..
                button_action] = button_images[button_color .. color_shade]
        end
    end
end

return theme
