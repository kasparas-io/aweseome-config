-- awesomewm fancy_taglist: a taglist that contains a tasklist for each tag.
-- Usage (add s.mytaglist to the wibar):
-- awful.screen.connect_for_each_screen(function(s)
--     ...
--     local fancy_taglist = require("fancy_taglist")
--     s.mytaglist = fancy_taglist.new({
--         screen = s,
--         taglist = { buttons = mytagbuttons },
--         tasklist = { buttons = mytasklistbuttons }
--     })
--     ...
-- end)
--
-- If you want rounded corners, try this in your theme:
-- theme.taglist_shape = function(cr, w, h)
--     return gears.shape.rounded_rect(cr, w, h, theme.border_radius)
-- end
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local theme = require("themes.Kasparas.theme")
local dpi = beautiful.xresources.apply_dpi
local box_height = dpi(0)
local box_width = dpi(12)
local icon_size = dpi(16)

local function box_margins(widget)
  return {
    {
      widget,
      widget = wibox.container.place
    },
    top = box_height,
    bottom = box_height,
    left = box_width,
    right = box_width,
    widget = wibox.container.margin
  }
end

local function constrain_icon(widget)
  return {
    {
      widget,
      height = icon_size,
      strategy = 'exact',
      widget = wibox.container.constraint
    },
    widget = wibox.container.place,
    halign = "right",
    valign = "right"
  }
end

local function fancy_tasklist(cfg, tag)
  local function only_this_tag(c, _)
    for _, t in ipairs(c:tags()) do if t == tag then return true end end
    return false
  end

  local overrides = {
    filter = only_this_tag,
    layout = {
      layout = wibox.layout.fixed.horizontal,
      spacing = dpi(8)
    },
    widget_template = {
      id = "clienticon",
      widget = awful.widget.clienticon,
      create_callback = function(self, c, _, _)
        self:get_children_by_id("clienticon")[1].client = c
      end
    }
  }
  return awful.widget.tasklist(gears.table.join(cfg, overrides))
end

local module = {}

-- @param cfg.screen
-- @param cfg.tasklist -> see awful.widget.tasklist
-- @param cfg.taglist  -> see awful.widget.taglist
function module.new(cfg)
  cfg = cfg or {}
  local taglist_cfg = cfg.taglist or {}
  local tasklist_cfg = cfg.tasklist or {}

  local screen = cfg.screen or awful.screen.focused()
  taglist_cfg.screen = screen
  tasklist_cfg.screen = screen

  local function update_callback(self, tag, _, _)
    -- make sure that empty tasklists take up no extra space
    local list_separator = self:get_children_by_id("list_separator")[1]
    if #tag:clients() == 0 then
      list_separator.spacing = dpi(2)
    else
      list_separator.spacing = dpi(6)
    end
  end

  local function create_callback(self, tag, _index, _tags)
    local tasklist = fancy_tasklist(tasklist_cfg, tag)
    self:get_children_by_id("tasklist_placeholder")[1]:add(tasklist)
    update_callback(self, tag, _index, _tags)
  end

  local overrides = {
    filter = awful.widget.taglist.filter.all,
    style = {
      squares_sel = "",
      squares_unsel = "",
      bg_focus = theme.bg_focus,
      bg_empty = theme.bg_primary,
      bg_occupied = theme.bg_primary,
      spacing = dpi(6),
      shape = function (cr, w, h)
        gears.shape.rounded_rect(cr, w, h, dpi(64))
      end
    },
    widget_template = {
      {
        box_margins {
          {
            widget = wibox.container.margin,
            left = dpi(3),
            {
              widget = wibox.widget.textbox,
              id = "text_role",
              align = "center",
              font = beautiful.font,
            },
          },
          -- tasklist
          constrain_icon {
            id = "tasklist_placeholder",
            layout = wibox.layout.fixed.horizontal
          },
          id = "list_separator",
          spacing = dpi(6),
          layout = wibox.layout.fixed.horizontal,
          {
            widget = wibox.container.margin,
            right = dpi(1),
          },
        },
        id = "background_role",
        widget = wibox.container.background,
      },
      border_width = dpi(2),
      border_color = "#ff0000",
      shape = function (cr, w, h)
        gears.shape.rounded_rect(cr, w, h, dpi(64))
      end,
      shape_border_width = dpi(1),
      shape_border_color = theme.border_focus,
      widget = wibox.container.background,
      create_callback = create_callback,
      update_callback = update_callback,
    }
  }
  return awful.widget.taglist(gears.table.join(taglist_cfg, overrides))
end

return module
