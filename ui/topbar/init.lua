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

  -- Create clock widget with larger font and center alignment
  local _clock = wibox.widget {
    widget = awful.widget.textclock,
    format = "<span font='RobotoMono Nerd Font 14'>%H:%M</span>",
    refresh = 30,
    align = "center" -- Add alignment
  }

  local clock = wibox.widget {
    _clock,
    widget = wibox.container.place,
    halign = "center",
    content_fill_horizontal = true
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
      layout = wibox.layout.align.horizontal,
      {
        widget = wibox.container.margin,
        top = dpi(6),
        bottom = dpi(6),
        left = dpi(6),
        right = dpi(6),
        s.taglist
      },
      {
        widget = wibox.container.margin,
        right = dpi(268),
        {
          layout = wibox.layout.fixed.horizontal,
          clock
        },
      },
      {
        widget = wibox.container.margin,
        top = dpi(6),
        bottom = dpi(6),
        left = dpi(6),
        right = dpi(6),
        {
          layout = wibox.layout.fixed.horizontal,
          awful.widget.keyboardlayout(),
          awful.widget.layoutbox(s),
        }
      },
    },
    bg = theme.bg_normal,
    widget = wibox.container.background,
    shape = gears.shape.rounded_rect,
    shape_border_width = 1,
    shape_border_color = theme.border_marked,
  }
end

return topbar
