local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  max_jobs = 20,
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use("wbthomason/packer.nvim") -- Have packer manage itself
  use("nvim-lua/popup.nvim")    -- An implementation of the Popup API from vim in Neovim
  use("nvim-lua/plenary.nvim")  -- Useful lua functions used ny lots of plugins
  use("windwp/nvim-autopairs")  -- Autopairs, integrates with both cmp and treesitter
  use("tpope/vim-commentary")
  use("nvim-tree/nvim-web-devicons")
  use("nvim-tree/nvim-tree.lua")
  use("akinsho/toggleterm.nvim")
  use("ahmedkhalf/project.nvim")
  use("goolord/alpha-nvim")
  use("antoinemadec/FixCursorHold.nvim") -- This is needed to fix lsp doc highlight
  use({
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  })
  use("simeji/winresizer")
  use("mvllow/modes.nvim")

  -- scrollbar & hlslens
  use("petertriho/nvim-scrollbar")
  use("kevinhwang91/nvim-hlslens")

  use({ "akinsho/bufferline.nvim", tag = "*", requires = "nvim-tree/nvim-web-devicons" })
  use("nvim-lualine/lualine.nvim")
  use("fgheng/winbar.nvim")

  -- Colorschemes
  use("dracula/vim")

  -- tmux
  use("aserowy/tmux.nvim")

  -- cmp plugins
  use("hrsh7th/nvim-cmp")         -- The completion plugin
  use("hrsh7th/cmp-buffer")       -- buffer completions
  use("hrsh7th/cmp-path")         -- path completions
  use("hrsh7th/cmp-cmdline")      -- cmdline completions
  use("saadparwaiz1/cmp_luasnip") -- snippet completions
  use("hrsh7th/cmp-nvim-lsp")
  use("ray-x/cmp-treesitter")
  use("hrsh7th/cmp-calc")
  use("hrsh7th/cmp-emoji")
  use("hrsh7th/cmp-omni")
  use("dmitmel/cmp-cmdline-history")
  use({ "vim-skk/skkeleton", requires = { "vim-denops/denops.vim" } })
  use({ "rinx/cmp-skkeleton", after = { "nvim-cmp", "skkeleton" } })

  -- Copilot.vim
  use({
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  })
  use({
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  })

  -- snippets
  use("L3MON4D3/LuaSnip")             --snippet engine
  use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

  -- LSP
  use("williamboman/mason.nvim")                   -- enable LSP
  use("williamboman/mason-lspconfig.nvim")         -- enable LSP
  use("WhoIsSethDaniel/mason-tool-installer.nvim") -- enable LSP
  use("neovim/nvim-lspconfig")                     -- enable LSP
  use({
    -- "henrywallace/null-ls.nvim",
    "nvimtools/none-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  })
  use("ray-x/lsp_signature.nvim")

  use({
    "nvimdev/lspsaga.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("lspsaga").setup({
        definition = { edit = "o", vsplit = "s", split = "i" },
      })
    end,
  })

  use({
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      require("fidget").setup({
        -- options
        window = {
          relative = "win", -- where to anchor, either "win" or "editor"
          blend = 0,        -- &winblend for the window
          zindex = nil,     -- the zindex value for the window
          border = "none",  -- style of border for the fidget window
        },
      })
    end,
  })

  -- Telescope
  use("nvim-telescope/telescope.nvim")
  use("nvim-telescope/telescope-media-files.nvim")
  use({
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  })
  use({ "nvim-telescope/telescope-ui-select.nvim" })
  use({
    "Allianaab2m/telescope-kensaku.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  })

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use("JoosepAlviste/nvim-ts-context-commentstring")
  use("windwp/nvim-ts-autotag")
  use("haringsrob/nvim_context_vt") -- display a virtual text
  use("p00f/nvim-ts-rainbow")
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  })
  use("kiyoon/treesitter-indent-object.nvim")

  -- Flutter
  use({ "akinsho/flutter-tools.nvim", requires = "nvim-lua/plenary.nvim" })

  -- Git
  use("lewis6991/gitsigns.nvim")
  use("dinhhuy258/git.nvim")

  -- browser
  use("tyru/open-browser.vim")

  -- nvim-notify
  use("rcarriga/nvim-notify")

  use("norcalli/nvim-colorizer.lua")

  -- quickrun
  use({ "thinca/vim-quickrun" })
  use({ "is0n/jaq-nvim" })

  -- markdown preview
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  })

  use("echasnovski/mini.surround")

  use("vim-denops/denops.vim")
  use("vim-denops/denops-helloworld.vim")
  use("yuki-yano/fuzzy-motion.vim")
  use("lambdalisue/kensaku.vim")
  use("lambdalisue/kensaku-command.vim")
  use("lambdalisue/kensaku-search.vim")
  use({
    "jedrzejboczar/possession.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
