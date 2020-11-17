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

theme.font = "SauceCodePro Nerd Font Semibold 10"

colors = {}

colors.base00 = xrdb.color0
colors.base01 = xrdb.color1
colors.base02 = xrdb.color2
colors.base03 = xrdb.color3
colors.base04 = xrdb.color4
colors.base05 = xrdb.color5
colors.base06 = xrdb.color6
colors.base07 = xrdb.color7
colors.base08 = xrdb.color8
colors.base09 = xrdb.color9
colors.base0A = xrdb.color10
colors.base0B = xrdb.color11
colors.base0C = xrdb.color12
colors.base0D = xrdb.color13
colors.base0E = xrdb.color14
colors.base0F = xrdb.color15

theme.bg_normal     = colors.base00
theme.bg_focus      = colors.base0D
theme.bg_urgent     = colors.base09
theme.bg_minimize   = colors.base09
theme.bg_systray    = colors.base03

theme.fg_normal     = colors.base05
theme.fg_focus      = colors.base00
theme.fg_urgent     = colors.base00
theme.fg_minimize   = colors.base00

theme.useless_gap   = dpi(3)
theme.border_width  = dpi(2)
theme.border_normal = colors.base03
theme.border_focus  = colors.base0D
theme.border_marked = colors.base0A

-- Taglist (workspace indicator)
theme.taglist_fg_focus = colors.base00
theme.taglist_bg_focus = colors.base0D
theme.taglist_fg_urgent = colors.base00
theme.taglist_bg_urgent = colors.base08
theme.taglist_fg_occupied = colors.base05
theme.taglist_bg_occupied = colors.base03
-- theme.taglist_fg_empty
-- theme.taglist_bg_empty
-- theme.taglist_fg_volatile
-- theme.taglist_bg_volatile

-- Tasklist (windows on workspace)
theme.tasklist_fg_focus = colors.base00
theme.tasklist_bg_focus = colors.base0D
theme.tasklist_fg_urgent = colors.base00
theme.tasklist_bg_urgent = colors.base08

-- Titlebar (window decorations)
theme.titlebar_fg_normal = colors.base05
theme.titlebar_bg_normal = colors.base00
theme.titlebar_fg_focus = colors.base00
theme.titlebar_bg_focus = colors.base0D
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

theme = theme_assets.recolor_titlebar( theme, colors.base05, "normal")
theme = theme_assets.recolor_titlebar( theme, colors.base03, "normal", "hover")
theme = theme_assets.recolor_titlebar( theme, colors.base01, "normal", "press")
theme = theme_assets.recolor_titlebar( theme, colors.base00, "focus")
theme = theme_assets.recolor_titlebar( theme, darker(theme.fg_focus, -60), "focus", "hover")
theme = theme_assets.recolor_titlebar( theme, colors.base01, "focus", "press")

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon( theme.menu_height, colors.base0E, colors.base00)

-- Generate taglist squares:
theme.taglist_squares_sel = theme_assets.taglist_squares_sel( dpi(5), colors.base05)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel( dpi(5), colors.base05)

-- Generate wallpaper:
local cairo = require("lgi").cairo
local gears_color = require("gears.color")

-- Try to determine if we are running light or dark colorscheme:
local bg_numberic_value = 0;
for s in theme.bg_normal:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
    bg_numberic_value = bg_numberic_value + tonumber("0x"..s);
end
local is_dark_bg = (bg_numberic_value < 383)

local wallpaper_bg = colors.base02
local wallpaper_fg = colors.base05
local wallpaper_alt_fg = colors.base0F
if not is_dark_bg then
    wallpaper_bg, wallpaper_fg = wallpaper_fg, wallpaper_bg
end
theme.wallpaper = function(s)
    return gen_wallpaper(wallpaper_bg, wallpaper_fg, wallpaper_alt_fg, s)
end


-- function getn (t)
--   if type(t.n) == "number" then return t.n end
--   local max = 0
--   for i, _ in t do
--     if type(i) == "number" and i>max then max=i end
--   end
--   return max
-- end



function gen_wallpaper(bg, fg, alt_fg, s)
    s = s or screen.primary
    local height = s.geometry.height
    local width = s.geometry.width
    local img = cairo.RecordingSurface(cairo.Content.COLOR,
    cairo.Rectangle { x = 0, y = 0, width = width, height = height })
    local cr = cairo.Context(img)

    -- background
    cr:set_source(gears_color(bg))
    cr:paint()

    local num_colors = 0
    for i in pairs(colors) do num_colors = num_colors+ 1 end

    local box_width = (width / num_colors + 1)
    local box_height = (height/ num_colors + 1)

    -- Draw boxes in all colors
    cr:translate(
    width/2 - ((box_width/2)*num_colors/2),
    height/2 - ((box_height/2)*num_colors/2))

    for key, color in next, colors do
        cr:set_source(gears_color(color))
        cr:rectangle( 0, 0, box_width, box_height)
        cr:fill()
        cr:translate(box_width/2, box_height/2)
    end

    cr:set_operator(cairo.Operator.OVER)

    return img
end


return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4
--
