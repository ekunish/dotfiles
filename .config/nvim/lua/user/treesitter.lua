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
    -- `ip` や `ap` のようにtextobjectを選択します。
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    -- 前後のtextobjectに移動します。
    move = {
      enable = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
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
    },

    -- 関数の引数の位置を交換します。
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },

    -- textobject全体をfloating windowを使って表示します。
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["df"] = "@function.outer",
        ["dF"] = "@class.outer",
      },
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
  context_commentstring = {
    enable = true,
  },
})

