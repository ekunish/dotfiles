vim.cmd [[
try
  colorscheme dracula
  highlight Normal ctermbg=NONE guibg=NONE
  highlight LineNr ctermbg=NONE guibg=NONE
  highlight Folded ctermbg=NONE guibg=NONE
  highlight EndOfBuffer ctermbg=NONE guibg=NONE
  highlight NonText ctermfg=141 guifg=MediumPurple1 ctermbg=NONE guibg=NONE
  highlight SpecialKey ctermfg=141 guifg=LightSteelBlue ctermbg=NONE guibg=NONE
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
