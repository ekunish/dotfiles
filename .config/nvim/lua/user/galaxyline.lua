local status_ok, gl  = pcall(require, "galaxyline")
if not status_ok then
  return
end


local colors = require("galaxyline.themes.colors").dracula

require("galaxyline.themes.spaceline")
