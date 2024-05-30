local status_ok, nvim_context_vt = pcall(require, "nvim_context_vt")
if not status_ok then
  return
end

nvim_context_vt.setup({
  -- Enable by default. You can disable and use :NvimContextVtToggle to maually enable.
  -- Default: true
  enabled = false,

  -- Override default virtual text prefix
  -- Default: '-->'
  -- prefix = "",
  prefix = "→",

  -- Override the internal highlight group name
  -- Default: 'ContextVt'
  highlight = "NvimContextVt",

  -- Disable virtual text for given filetypes
  -- Default: { 'markdown' }
  disable_ft = { "markdown" },

  -- Disable display of virtual text below blocks for indentation based languages like Python
  -- Default: false
  disable_virtual_lines = false,

  -- Same as above but only for spesific filetypes
  -- Default: {}
  -- disable_virtual_lines_ft = { "yaml" },

  -- How many lines required after starting position to show virtual text
  -- Default: 1 (equals two lines total)
  min_rows = 1,

  -- Same as above but only for spesific filetypes
  -- Default: {}
  min_rows_ft = {},
})
