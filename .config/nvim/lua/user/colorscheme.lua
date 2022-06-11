-- vim.cmd([[
-- try
--   colorscheme dracula
--   highlight Normal ctermbg=NONE guibg=NONE
--   highlight LineNr ctermbg=NONE guibg=NONE
--   highlight Folded ctermbg=NONE guibg=NONE
--   highlight DiffDelete guibg=NONE ctermbg=NONE guifg=#FF5555 ctermfg=red
--   highlight EndOfBuffer ctermbg=NONE guibg=NONE
--   highlight NonText ctermfg=141 guifg=MediumPurple1 ctermbg=NONE guibg=NONE
--   highlight SpecialKey ctermfg=141 guifg=LightSteelBlue ctermbg=NONE guibg=NONE
-- catch /^Vim\%((\a\+)\)\=:E185/
--   colorscheme default
--   set background=dark
-- endtry
-- ]])

-- Lua:
vim.cmd([[colorscheme dracula]])

vim.cmd([[highlight NvimContextVt ctermbg=NONE guibg=NONE guifg=#6B6B6B]])
vim.cmd([[highlight LspDiagnosticsDefaultHint ctermbg=NONE guibg=NONE guifg=#BD93F9]])
vim.cmd([[highlight String ctermbg=NONE guibg=NONE guifg=#BD93F9]])
vim.cmd([[highlight Tag ctermbg=NONE guibg=NONE guifg=#BD93F9]])
vim.cmd([[highlight DiagnosticInfo ctermbg=NONE guibg=NONE guifg=#BD93F9]])
vim.cmd([[highlight DiagnosticHint ctermbg=NONE guibg=NONE guifg=#BD93F9]])
vim.cmd([[highlight SpecialComment ctermbg=NONE guibg=NONE guifg=#BD93F9]])
vim.cmd([[
try
  highlight Normal ctermbg=NONE guibg=NONE
  highlight LineNr ctermbg=NONE guibg=NONE
  highlight Folded ctermbg=NONE guibg=NONE
  highlight DiffDelete guibg=NONE ctermbg=NONE guifg=#FF5555 ctermfg=red
  " highlight EndOfBuffer ctermbg=NONE guibg=NONE
  highlight NonText ctermfg=141 guifg=MediumPurple1 ctermbg=NONE guibg=NONE
  highlight SpecialKey ctermfg=141 guifg=LightSteelBlue ctermbg=NONE guibg=NONE
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])

require("notify").setup({
  background_colour = "#000000",
})

-- customize dracula color palette
-- vim.g.dracula_colors = {
--   -- bg = "#282A36",
--   bg = "#FFFFFF",
--   fg = "#F8F8F2",
--   selection = "#44475A",
--   comment = "#6272A4",
--   red = "#FF5555",
--   orange = "#FFB86C",
--   yellow = "#F1FA8C",
--   green = "#50fa7b",
--   purple = "#BD93F9",
--   cyan = "#8BE9FD",
--   pink = "#FF79C6",
--   bright_red = "#FF6E6E",
--   bright_green = "#69FF94",
--   bright_yellow = "#FFFFA5",
--   bright_blue = "#D6ACFF",
--   bright_magenta = "#FF92DF",
--   bright_cyan = "#A4FFFF",
--   bright_white = "#FFFFFF",
--   menu = "#21222C",
--   visual = "#3E4452",
--   gutter_fg = "#4B5263",
--   nontext = "#3B4048",
-- }

-- -- show the '~' characters after the end of buffers
-- vim.g.dracula_show_end_of_buffer = true
-- -- use transparent background
-- vim.g.dracula_transparent_bg = true
-- -- set custom lualine background color
-- vim.g.dracula_lualine_bg_color = "#F8F8F2"
-- -- set italic comment
-- vim.g.dracula_italic_comment = true
