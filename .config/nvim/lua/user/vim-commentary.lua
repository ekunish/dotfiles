local status_ok, vim_commentary = pcall(require, "vim-commentary")
if not status_ok then
  return
end

vim_commentary.setup({})
