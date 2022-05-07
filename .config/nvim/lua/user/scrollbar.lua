local status_ok, scrollbar = pcall(require, "scrollbar.handlers.search")
if not status_ok then
  return
end

scrollbar.setup({})

-- require("scrollbar.handlers.search").setup()
