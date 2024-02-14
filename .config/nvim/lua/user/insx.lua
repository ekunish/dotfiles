local status_ok, insx = pcall(require, "insx")
if not status_ok then
  return
end

insx.preset.standard.setup({})
