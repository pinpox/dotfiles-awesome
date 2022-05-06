
local M = {}

local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")

-- Widget and layout library
local wibox = require("wibox")


-- Theme handling library
local beautiful = require("beautiful")

-- Themes define colours, icons, font and wallpapers. The environment variable
-- provides an option to override the default, e.g. when running in xephyr
beautiful.init(os.getenv("AWESOME_THEME") or "~/.config/awesome/theme.lua")


-- Add a gap around clients
beautiful.useless_gap  = 5

-- Signal function to execute when a new client appears.
M["manage"] = function (c)

		-- Rounded corners for all clients, 5px radius
		c.shape = function(cr,w,h)
				gears.shape.rounded_rect(cr,w,h,5)
		end
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		-- if not awesome.startup then awful.client.setslave(c) end

		if awesome.startup
				and not c.size_hints.user_position
				and not c.size_hints.program_position then
				-- Prevent clients from being unreachable after screen count changes.
				awful.placement.no_offscreen(c)
		end
end




-- Add a titlebar if titlebars_enabled is set to true in the rules.
M["request::titlebars"] =  function(c)
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

		-- local titlebar = awful.titlebar(c, {
		--     height = 24
		-- })

		awful.titlebar(c) : setup {
				{
						-- Left
						{
								-- add margin around titlebar icons
								awful.titlebar.widget.iconwidget(c),
								layout = wibox.container.margin,
								top = 5,
								left = 5,
								bottom = 5
						},
						buttons = buttons,
						layout  = wibox.layout.fixed.horizontal
				},
				{
						-- Middle
						{
								-- Title
								align  = "center",
								widget = awful.titlebar.widget.titlewidget(c)
						},
						buttons = buttons,
						layout  = wibox.layout.flex.horizontal
				},
				{
						-- Right
						{
								awful.titlebar.widget.floatingbutton (c),
								awful.titlebar.widget.stickybutton   (c),
								-- awful.titlebar.widget.ontopbutton    (c),
								awful.titlebar.widget.closebutton    (c),
								layout = wibox.layout.fixed.horizontal()
						},
						layout = wibox.container.margin,
						top = 3,
						left = 3,
						right = 3,
						bottom = 3
				},
				layout = wibox.layout.align.horizontal
		}
end

-- Enable sloppy focus, so that focus follows mouse.
M["mouse::enter"] =  function(c)
		c:emit_signal("request::activate", "mouse_enter", {raise = false})
end

M["focus"] =  function(c)
		c.border_color = beautiful.border_focus
end

-- M["property::floating"] =  function(c)
-- 		c.border_color = beautiful.border_focus
-- end

M["property::floating"] = function(c)
    -- if c.maximized or c.fullscreen then return end
    naughty.notify { text = c.floating and "floating" or "not floating" }
end

M["unfocus"] = function(c) c.border_color = beautiful.border_normal end


return M


