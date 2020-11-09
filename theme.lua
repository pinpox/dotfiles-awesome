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

theme.font          = "SauceCodePro Nerd Font Semibold 10"

base00 = xrdb.color0
base01 = xrdb.color1
base02 = xrdb.color2
base03 = xrdb.color3
base04 = xrdb.color4
base05 = xrdb.color5
base06 = xrdb.color6
base07 = xrdb.color7
base08 = xrdb.color8
base09 = xrdb.color9
base0A = xrdb.color10
base0B = xrdb.color11
base0C = xrdb.color12
base0D = xrdb.color13
base0E = xrdb.color14
base0F = xrdb.color15

theme.bg_normal     = base00
theme.bg_focus      = base0D
theme.bg_urgent     = base09
theme.bg_minimize   = base09
theme.bg_systray    = base03

theme.fg_normal     = base05
theme.fg_focus      = base00
theme.fg_urgent     = base00
theme.fg_minimize   = base00

theme.useless_gap   = dpi(3)
theme.border_width  = dpi(2)
theme.border_normal = base03
theme.border_focus  = base0D
theme.border_marked = base0A

-- Taglist (workspace indicator)
theme.taglist_fg_focus = base00
theme.taglist_bg_focus = base0D
theme.taglist_fg_urgent = base00
theme.taglist_bg_urgent = base08
theme.taglist_fg_occupied = base05
theme.taglist_bg_occupied = base03
-- theme.taglist_fg_empty
-- theme.taglist_bg_empty
-- theme.taglist_fg_volatile
-- theme.taglist_bg_volatile

-- Tasklist (windows on workspace)
theme.tasklist_fg_focus = base00
theme.tasklist_bg_focus = base0D
theme.tasklist_fg_urgent = base00
theme.tasklist_bg_urgent = base08

-- Titlebar (window decorations)
theme.titlebar_fg_normal = base05
theme.titlebar_bg_normal = base00
theme.titlebar_fg_focus = base00
theme.titlebar_bg_focus = base0D
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

theme = theme_assets.recolor_titlebar( theme, base05, "normal")
theme = theme_assets.recolor_titlebar( theme, base03, "normal", "hover")
theme = theme_assets.recolor_titlebar( theme, base01, "normal", "press")
theme = theme_assets.recolor_titlebar( theme, base00, "focus")
theme = theme_assets.recolor_titlebar( theme, darker(theme.fg_focus, -60), "focus", "hover")
theme = theme_assets.recolor_titlebar( theme, base01, "focus", "press")

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon( theme.menu_height, base0E, base00)

-- Generate taglist squares:
theme.taglist_squares_sel = theme_assets.taglist_squares_sel( dpi(5), base05)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel( dpi(5), base05)

-- Try to determine if we are running light or dark colorscheme:
local bg_numberic_value = 0;
for s in theme.bg_normal:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
    bg_numberic_value = bg_numberic_value + tonumber("0x"..s);
end
local is_dark_bg = (bg_numberic_value < 383)

-- Generate wallpaper:
local wallpaper_bg = base02
local wallpaper_fg = base05
local wallpaper_alt_fg = base0F
if not is_dark_bg then
    wallpaper_bg, wallpaper_fg = wallpaper_fg, wallpaper_bg
end
theme.wallpaper = function(s)
    return theme_assets.wallpaper(wallpaper_bg, wallpaper_fg, wallpaper_alt_fg, s)
end

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4
