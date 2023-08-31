local wezterm = require("wezterm")
local dracula = require("dracula")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return {
  font = wezterm.font("HackGen Console NF", { weight = "Regular", italic = false }),
  -- font = wezterm.font("PlemolJP Console NF", { weight = "Regular", italic = false }),
  use_ime = true,
  audible_bell = "Disabled",
  colors = dracula,
  font_size = 13, -- 18,
  -- term = "xterm-256color",
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  window_background_opacity = 0.94,
  text_background_opacity = 1.0,
  -- tab_bar_at_bottom = true,
  use_fancy_tab_bar = true,
  keys = {
    { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
  },
}
