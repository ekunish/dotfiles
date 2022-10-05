local status_ok, symbols = pcall(require, "symbols-outlines")
if not status_ok then
  return
end

symbols.setup()

