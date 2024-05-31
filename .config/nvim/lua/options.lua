vim.cmd([[
set termguicolors
"set mouse="a"
set clipboard+=unnamedplus
"set fileencoding="utf-8"
set number
set numberwidth=3
set signcolumn=yes
set smartcase
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set tabstop=4
set showtabline=4
set cmdheight=1
set noswapfile
set undofile
set nowrap
set hlsearch
set incsearch
set autoread
set whichwrap=b,s,h,l,<,>,[,]
set nobackup
set wildmenu
set visualbell
set cursorline
set hidden
set list
"set listchars=tab:>\ ,extends:<
set showmatch
set matchtime=1
set matchpairs& matchpairs+=<:>
set backspace=indent,eol,start
]])

vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
    pattern = { '*' },
    callback = function()
        vim.api.nvim_exec('silent! normal! g`"zv', false)
    end,
})

