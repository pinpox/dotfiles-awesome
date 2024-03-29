
local hotkeys_popup = require("awful.hotkeys_popup")
local awful = require("awful")
mymainmenu = awful.menu(
{
		items = {
				{ "edit config", EditorCmd .. " " .. awesome.conffile },
				{ "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
				{ "manual", Terminal .. " -e man awesome" },
				{ "restart", awesome.restart },
				{ "quit", function() awesome.quit() end },
		}
}
)
