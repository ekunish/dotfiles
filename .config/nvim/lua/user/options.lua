if vim.loader then
  vim.loader.enable()
end

local options = {
  backup = false, -- creates a backup file
  clipboard = "unnamedplus", -- allows neovim to access the system clipboard
  cmdheight = 1, -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0, -- so that `` is visible in markdown files
  fileencoding = "utf-8", -- the encoding written to a file
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  incsearch = true, -- highlight the current search pattern
  inccommand = "nosplit",
  mouse = "a", -- allow the mouse to be used in neovim
  pumheight = 15, -- pop up menu height
  -- pumblend = 10, -- pop up menu transparency
  -- winblend = 10, -- window transparency
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2, -- always show tabs
  smartcase = true, -- smart case
  smartindent = true, -- make indenting smarter again
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 100, -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true, -- enable persistent undo
  updatetime = 300, -- faster completion (4000ms default)
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true, -- convert tabs to spaces
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  tabstop = 2, -- insert 2 spaces for a tab
  cursorline = false, -- highlight the current line
  number = true, -- set numbered lines
  relativenumber = false, -- set relative numbered lines
  numberwidth = 3, -- set number column width to 2 {default 4}
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  wrap = false, -- display lines as one long line
  scrolloff = 8, -- is one of my fav
  sidescrolloff = 8,
  -- guifont = "monospace:h17",               -- the font used in graphical neovim applications
  list = true,
  linespace = 0,
  -- spelllang = { en },
}

vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")
vim.opt.listchars:append("trail:-")
vim.opt.listchars:append("extends:»")
vim.opt.listchars:append("tab:»-")

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[lang en_US.UTF-8]])
-- vim.cmd([[set formatoptions-=cro]]) -- TODO: this doesn't seem to work

vim.wo.signcolumn = "yes"

-- vim.cmd("let g:python3_host_prog = '/opt/homebrew/Caskroom/miniforge/base/bin/python'")

-- local function isempty(s)
--   return s == nil or s == ""
-- end
-- local function use_if_defined(val, fallback)
--   return val ~= nil and val or fallback
-- end

-- local conda_prefix = os.getenv("CONDA_PREFIX")
-- if not isempty(conda_prefix) then
--   vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, conda_prefix .. "/bin/python")
--   vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, conda_prefix .. "/bin/python")
-- else
--   vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, "python")
--   vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, "python3")
-- end
