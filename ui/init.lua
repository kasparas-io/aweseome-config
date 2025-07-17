local awful = require("awful")
local topbar = require("ui.topbar")


awful.screen.connect_for_each_screen(function (s)
  topbar(s)
end)
