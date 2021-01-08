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
local theme = dofile(themes_path.."default/theme.lua")
-- load vector assets' generators for this theme

theme.font = "Sauce Code Pro Nerd Font Semibold 9"

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

theme.bg_normal     = palette.base00
theme.bg_focus      = palette.base0D
theme.bg_urgent     = palette.base09
theme.bg_minimize   = palette.base09
theme.bg_systray    = palette.base00

theme.fg_normal     = palette.base05
theme.fg_focus      = palette.base00
theme.fg_urgent     = palette.base00
theme.fg_minimize   = palette.base00

theme.useless_gap   = dpi(3)
theme.border_width  = dpi(2)
theme.border_normal = palette.base03
theme.border_focus  = palette.base0D
theme.border_marked = palette.base0A

-- Taglist (workspace indicator)
theme.taglist_fg_focus = palette.base00
theme.taglist_bg_focus = palette.base0D
theme.taglist_fg_urgent = palette.base00
theme.taglist_bg_urgent = palette.base08
theme.taglist_fg_occupied = palette.base05
theme.taglist_bg_occupied = palette.base03
-- theme.taglist_fg_empty
-- theme.taglist_bg_empty
-- theme.taglist_fg_volatile
-- theme.taglist_bg_volatile

-- Tasklist (windows on workspace)
theme.tasklist_fg_focus = palette.base00
theme.tasklist_bg_focus = palette.base0D
theme.tasklist_fg_urgent = palette.base00
theme.tasklist_bg_urgent = palette.base08

-- Titlebar (window decorations)
theme.titlebar_fg_normal = palette.base05
theme.titlebar_bg_normal = palette.base00
theme.titlebar_fg_focus = palette.base00
theme.titlebar_bg_focus = palette.base0D
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

theme = theme_assets.recolor_titlebar( theme, palette.base05, "normal")
theme = theme_assets.recolor_titlebar( theme, palette.base03, "normal", "hover")
theme = theme_assets.recolor_titlebar( theme, palette.base01, "normal", "press")
theme = theme_assets.recolor_titlebar( theme, palette.base00, "focus")
theme = theme_assets.recolor_titlebar( theme, darker(theme.fg_focus, -60), "focus", "hover")
theme = theme_assets.recolor_titlebar( theme, palette.base01, "focus", "press")

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon( theme.menu_height, palette.base0E, palette.base00)

-- Generate taglist squares:
theme.taglist_squares_sel = theme_assets.taglist_squares_sel( dpi(5), palette.base05)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel( dpi(5), palette.base05)

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
    generator(cr, palette, width, height)
    return img
end

-- function getn (t)
--   if type(t.n) == "number" then return t.n end
--   local max = 0
--   for i, _ in t do
--     if type(i) == "number" and i>max then max=i end
--   end
--   return max
-- end

function squircle(size, fg)
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, size, size)
    local cr = cairo.Context(img)

    cr:set_source(gears.color.transparent)
    cr:paint()

    local width, height = size, size

    local degrees = math.pi / 180.0

    cr:new_sub_path()
    cr:arc(size/2,size/2, size/3, 0 * degrees, 360 * degrees)
    cr:close_path()

    cr:set_source(gears.color(fg))
    cr:fill_preserve()
    cr:stroke()

    return img
end


theme.button_red_normal = squircle(24, xrdb.color8)
theme.button_red_focus = squircle(24, xrdb.color8)
theme.button_red_hover = squircle(24, darker(xrdb.color8, -60))
theme.button_red_press = squircle(24, darker(xrdb.color8, 60))

theme.button_yellow_focus = squircle(24, xrdb.color10)
theme.button_yellow_normal = squircle(24, xrdb.color10)
theme.button_yellow_hover = squircle(24, xrdb.color10)
theme.button_yellow_press = squircle(24, xrdb.color10)

theme.button_green_focus = squircle(24, xrdb.color11)
theme.button_green_normal = squircle(24, xrdb.color11)
theme.button_green_hover = squircle(24, xrdb.color11)
theme.button_green_press = squircle(24, xrdb.color11)

theme.button_blue_focus = squircle(24, xrdb.color11)
theme.button_blue_normal = squircle(24, xrdb.color11)
theme.button_blue_hover = squircle(24, xrdb.color11)
theme.button_blue_press = squircle(24, xrdb.color11)

-- Close button
theme.titlebar_close_button_normal = theme.button_red_normal --close_button_normal.
theme.titlebar_close_button_focus = theme.button_red_focus --close_button_focus.
theme.titlebar_close_button_focus_hover = theme.button_red_hover --close_button_focus_hover.
theme.titlebar_close_button_focus_press = theme.button_red_press --close_button_focus_press.

theme.titlebar_floating_button_focus = theme.button_green_focus --floating_button_focus.
theme.titlebar_floating_button_focus_active = theme.button_green_focus --floating_button_focus_active.
theme.titlebar_floating_button_focus_active_hover = theme.button_green_focus --floating_button_focus_active_hover.
theme.titlebar_floating_button_focus_active_press = theme.button_green_focus --floating_button_focus_active_press.
theme.titlebar_floating_button_focus_inactive = theme.button_green_focus --floating_button_focus_inactive.
theme.titlebar_floating_button_focus_inactive_hover = theme.button_green_focus --floating_button_focus_inactive_hover.
theme.titlebar_floating_button_focus_inactive_press = theme.button_green_focus --floating_button_focus_inactive_press.

theme.titlebar_floating_button_normal = theme.button_green_focus --floating_button_normal.
theme.titlebar_floating_button_normal_active = theme.button_green_focus --floating_button_normal_active.
theme.titlebar_floating_button_normal_active_hover = theme.button_green_focus --floating_button_normal_active_hover.
theme.titlebar_floating_button_normal_active_press = theme.button_green_focus --floating_button_normal_active_press.
theme.titlebar_floating_button_normal_inactive = theme.button_green_focus --floating_button_normal_inactive.
theme.titlebar_floating_button_normal_inactive_hover = theme.button_green_focus --floating_button_normal_inactive_hover.
theme.titlebar_floating_button_normal_inactive_press = theme.button_green_focus --floating_button_normal_inactive_press.

theme.titlebar_maximized_button_focus = theme.button_red_focus --maximized_button_focus.
theme.titlebar_maximized_button_focus_active = theme.button_red_focus --maximized_button_focus_active.
theme.titlebar_maximized_button_focus_active_hover = theme.button_red_focus --maximized_button_focus_active_hover.
theme.titlebar_maximized_button_focus_active_press = theme.button_red_focus --maximized_button_focus_active_press.
theme.titlebar_maximized_button_focus_inactive = theme.button_red_focus --maximized_button_focus_inactive.
theme.titlebar_maximized_button_focus_inactive_hover = theme.button_red_focus --maximized_button_focus_inactive_hover.
theme.titlebar_maximized_button_focus_inactive_press = theme.button_red_focus --maximized_button_focus_inactive_press.

theme.titlebar_maximized_button_normal = theme.button_red_focus --maximized_button_normal.
theme.titlebar_maximized_button_normal_active = theme.button_red_focus --maximized_button_normal_active.
theme.titlebar_maximized_button_normal_active_hover = theme.button_red_focus --maximized_button_normal_active_hover.
theme.titlebar_maximized_button_normal_active_press = theme.button_red_focus --maximized_button_normal_active_press.
theme.titlebar_maximized_button_normal_inactive = theme.button_red_focus --maximized_button_normal_inactive.
theme.titlebar_maximized_button_normal_inactive_hover = theme.button_red_focus --maximized_button_normal_inactive_hover.
theme.titlebar_maximized_button_normal_inactive_press = theme.button_red_focus --maximized_button_normal_inactive_press.

theme.titlebar_sticky_button_focus = theme.button_yellow_focus --sticky_button_focus.
theme.titlebar_sticky_button_focus_active = theme.button_yellow_focus --sticky_button_focus_active.
theme.titlebar_sticky_button_focus_active_hover = theme.button_yellow_focus --sticky_button_focus_active_hover.
theme.titlebar_sticky_button_focus_active_press = theme.button_yellow_focus --sticky_button_focus_active_press.
theme.titlebar_sticky_button_focus_inactive = theme.button_yellow_focus --sticky_button_focus_inactive.
theme.titlebar_sticky_button_focus_inactive_hover = theme.button_yellow_focus --sticky_button_focus_inactive_hover.
theme.titlebar_sticky_button_focus_inactive_press = theme.button_yellow_focus --sticky_button_focus_inactive_press.
theme.titlebar_sticky_button_normal = theme.button_yellow_focus --sticky_button_normal.
theme.titlebar_sticky_button_normal_active = theme.button_yellow_focus --sticky_button_normal_active.
theme.titlebar_sticky_button_normal_active_hover = theme.button_yellow_focus --sticky_button_normal_active_hover.
theme.titlebar_sticky_button_normal_active_press = theme.button_yellow_focus --sticky_button_normal_active_press.
theme.titlebar_sticky_button_normal_inactive = theme.button_yellow_focus --sticky_button_normal_inactive.
theme.titlebar_sticky_button_normal_inactive_hover = theme.button_yellow_focus --sticky_button_normal_inactive_hover.
theme.titlebar_sticky_button_normal_inactive_press = theme.button_yellow_focus --sticky_button_normal_inactive_press.


-- theme.button_normal = squircle(32, xrdb.color7, 12)
-- theme.button_focus = squircle(32, xrdb.color15, 12)
-- theme.button_active = squircle(32, xrdb.color12, 12)
-- theme.button_normal_active = squircle(32, xrdb.color4, 12)

-- theme.titlebar_floating_button_focus_active = theme.button_active
-- theme.titlebar_floating_button_focus_inactive  = theme.button_focus
-- theme.titlebar_floating_button_normal_active = theme.button_normal_active
-- theme.titlebar_floating_button_normal_inactive  = theme.button_normal

-- theme.titlebar_sticky_button_focus_active = theme.button_active
-- theme.titlebar_sticky_button_focus_inactive  = theme.button_focus
-- theme.titlebar_sticky_button_normal_active = theme.button_normal_active
-- theme.titlebar_sticky_button_normal_inactive  = theme.button_normal

-- theme.titlebar_ontop_button_focus_active = theme.button_active
-- theme.titlebar_ontop_button_focus_inactive  = theme.button_focus
-- theme.titlebar_ontop_button_normal_active = theme.button_normal_active
-- theme.titlebar_ontop_button_normal_inactive  = theme.button_normal

-- theme.titlebar_close_button_normal = squircle(32, xrdb.color3, 12)
-- theme.titlebar_close_button_focus = squircle(32, xrdb.color8, 12)


return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4
