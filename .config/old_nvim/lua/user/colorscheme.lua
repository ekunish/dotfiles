require("notify").setup({
  background_colour = "#000000",
})

vim.cmd([[
try
  colorscheme dracula

  highlight Normal ctermbg=NONE guibg=NONE
  highlight LineNr ctermbg=NONE guibg=NONE
  highlight Folded ctermbg=NONE guibg=NONE
  highlight NvimContextVt ctermbg=NONE guibg=NONE guifg=#6B6B6B
  highlight LspDiagnosticsDefaultHint ctermbg=NONE guibg=NONE guifg=#BD93F9
  highlight String ctermbg=NONE guibg=NONE guifg=#BD93F9
  highlight Tag ctermbg=NONE guibg=NONE guifg=#BD93F9
  highlight DiagnosticInfo ctermbg=NONE guibg=NONE guifg=#BD93F9
  highlight DiagnosticHint ctermbg=NONE guibg=NONE guifg=#BD93F9
  highlight SpecialComment ctermbg=NONE guibg=NONE guifg=#BD93F9
  highlight DiffDelete guibg=NONE ctermbg=NONE guifg=#FF5555 ctermfg=red
  highlight NonText ctermfg=141 guifg=MediumPurple1 ctermbg=NONE guibg=NONE
  highlight SpecialKey ctermfg=141 guifg=LightSteelBlue ctermbg=NONE guibg=NONE

  highlight WhichKeyFloat ctermbg=NONE
  highlight WhichKeySeparator ctermbg=NONE

  highlight LspFloatWinNormal ctermbg=NONE guibg=NONE
  highlight SagaShadow ctermbg=NONE guibg=NONE
  highlight Float ctermbg=NONE guibg=NONE
  highlight FloatShadow ctermbg=NONE guibg=NONE
  highlight FloatShadowThrough ctermbg=NONE guibg=NONE
  highlight! link FloatBorder Normal
  highlight! link NormalFloat Normal

catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])
