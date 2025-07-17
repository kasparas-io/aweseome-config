local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local taglist = require("ui.topbar.taglist")
local theme = require("themes.Kasparas.theme")
local dpi = xresources.apply_dpi

local function topbar(s)


  s.taglist = taglist.new({
    screen = s,
  })

  -- Create clock widget with larger font
  local clock = wibox.widget {
    widget = awful.widget.textclock,
    format = "<span font='RobotoMono Nerd Font 14'>%H:%M</span>",
    refresh = 30
  }

  local wibar = awful.wibar({
    position = "top",
    screen = s,
    height = dpi(36),
    width = s.geometry.width - 40,
    x = 20,
    bg = "transparent",
  })

  wibar:setup {
    {
      {
        -- Left widgets
        {
          widget = wibox.container.margin,
          top = dpi(6),
          bottom = dpi(6),
          left = dpi(6),
          right = dpi(6),
          s.taglist
        },
        layout = wibox.layout.fixed.horizontal
      },
      -- Middle widget (clock)
      {
        clock,
        layout = wibox.layout.fixed.horizontal,
        spacing = 0,
      },
      -- Right widgets
      {
        layout = wibox.layout.fixed.horizontal
      },
      layout = wibox.layout.align.horizontal,
      expand = "outside"  -- This is the key change
    },
    bg = theme.bg_normal,
    widget = wibox.container.background,
    shape = gears.shape.rounded_rect,
    shape_border_width = 1,
    shape_border_color = theme.border_marked,
  }
end

return topbar
