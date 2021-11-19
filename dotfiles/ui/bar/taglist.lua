
local awful = require("awful")


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
awful.button({ }, 1, function(t) t:view_only() end),
awful.button({ Modkey }, 1, function(t)
	if client.focus then
		client.focus:move_to_tag(t)
	end
end),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ Modkey }, 3, function(t)
	if client.focus then
		client.focus:toggle_tag(t)
	end
end),

-- Scroll on taglist
awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

	awful.widget.taglist {
		screen  = s,
		style = {
			shape =  round_rect2,
		},
		widget_template = {
			{
				{
					id     = 'tag_number',
					widget = wibox.widget.textbox,
				},
				margins = 4,
				widget  = wibox.container.margin,
			},
			-- TODO change background when not focused
			fg = '#000000',
			id     = 'background_role',
			widget = wibox.container.background,

			-- Add support for hover colors and an index label
			create_callback = function(self, c3, index, objects) --luacheck: no unused args
				self:get_children_by_id('tag_number')[1].markup = '<b> '..c3.name..' </b>'
			end,
			update_callback = function(self, c3, index, objects) --luacheck: no unused args
				self:get_children_by_id('tag_number')[1].markup = '<b> '..c3.name..' </b>'
			end
		},
		-- Only show tags that are not empty
		filter  = awful.widget.taglist.filter.noempty,
		buttons = taglist_buttons
	}
