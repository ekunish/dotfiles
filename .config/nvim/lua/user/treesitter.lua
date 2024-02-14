local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup({
  -- A list of parser names, or "all"
  -- ensure_installed = "all",
  ensure_installed = {
    "c",
    "lua",
    "rust",
    "typescript",
    "tsx",
    "python",
    "php",
    "json",
    "javascript",
    "comment",
    "c_sharp",
    "cpp",
    "css",
    "html",
    "http",
    "dart",
    "dockerfile",
    "dot",
    "glsl",
    "markdown",
    "markdown_inline",
    "vim",
    "swift",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  -- -- Install parsers synchronously (only applied to `ensure_installed`)
  -- sync_install = false,

  -- -- List of parsers to ignore installing (for "all")
  -- -- ignore_install = { "javascript" },

  incremental_selection = {
    enable = true,

    keymaps = {
      -- 範囲選択を開始します。
      init_selection = "gnn",

      -- 1つ上のnodeに選択範囲を拡大します。
      node_incremental = "grn",

      -- 1つ上のスコープに選択範囲を拡大します。
      scope_incremental = "grc",

      -- 1つ下のnodeに選択範囲を縮小します。
      node_decremental = "grm",
    },
  },

  indent = {
    enable = true,
  },

  textobjects = {
    lsp_interop = {
      enable = true,
      border = "none",
      floating_preview_opts = {},
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]d"] = "@conditional.outer",
      },
      goto_previous = {
        ["[d"] = "@conditional.outer",
      },
    },
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
  },

  refactor = {
    -- カーソルの下にあるsymbolの定義位置に移動したり、
    -- 定義されているsymbol一覧を表示します。
    navigation = {
      enable = true,
      keymaps = {
        -- 定義に移動します。
        goto_definition = "gnd",

        -- 定義一覧を表示します。
        list_definitions = "gnD",

        -- 定義一覧を本の目次のようにネストがわかるように表示します。
        list_definitions_toc = "gO",

        -- カーソル下のsymbolの前後の利用位置に移動します。
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      },
    },

    -- カーソルの下にあるsymbolをrenameします。
    smart_rename = {
      enable = true,
      keymaps = {
        -- `grr` でrename処理が開始できます。
        smart_rename = "grr",
      },
    },
    -- カーソルの下にあるsymbolをhighlightします。
    highlight_definitions = { enable = true },

    -- カーソルが存在するスコープ全体をhighlightします。
    highlight_current_scope = { enable = true },
  },

  autotag = {
    enable = true,
  },
  -- context_commentstring = {
  --   enable = true,
  -- },
})

require("nvim-tree").setup({})
require("ts_context_commentstring").setup({})
vim.g.skip_ts_context_commentstring_module = true
