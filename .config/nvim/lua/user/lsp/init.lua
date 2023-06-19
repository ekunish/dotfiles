local on_attach = function(client, bufnr)
  -- LSPが持つフォーマット機能を無効化する
  -- →例えばtsserverはデフォルトでフォーマット機能を提供しますが、利用したくない場合はコメントアウトを解除してください
  -- client.server_capabilities.documentFormattingProvider = false
end

-- 補完プラグインであるcmp_nvim_lspをLSPと連携させています（後述）
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local settings = {
  Lua = {
    diagnostics = { globals = { "vim" } },
  },
}

require("mason-tool-installer").setup({

  -- a list of all tools you want to ensure are installed upon
  -- start; they should be the names Mason uses for each tool
  ensure_installed = {

    -- you can pin a tool to a particular version
    -- { 'golangci-lint', version = 'v1.47.0' },

    -- you can turn off/on auto_update per tool
    { "bash-language-server", auto_update = true },

    "clangd",
    "json-lsp",
    "prettier",
    "pyright",
    "rust-analyzer",
    "tailwindcss-language-server",
    "typescript-language-server",
    "yaml-language-server",
    "lua-language-server",
    "vim-language-server",
    "stylua",
    "shellcheck",
    "editorconfig-checker",
    -- 'gopls',
    -- 'gofumpt',
    -- 'golines',
    -- 'gomodifytags',
    -- 'gotests',
    -- 'impl',
    -- 'json-to-struct',
    -- 'luacheck',
    -- 'misspell',
    -- 'revive',
    "shellcheck",
    -- 'shfmt',
    -- 'staticcheck',
    "vint",
  },

  -- if set to true this will check each tool for updates. If updates
  -- are available the tool will be updated. This setting does not
  -- affect :MasonToolsUpdate or :MasonToolsInstall.
  -- Default: false
  auto_update = true,

  -- automatically install / update on startup. If set to false nothing
  -- will happen on startup. You can use :MasonToolsInstall or
  -- :MasonToolsUpdate to install tools and check for updates.
  -- Default: true
  run_on_start = true,

  -- set a delay (in ms) before the installation starts. This is only
  -- effective if run_on_start is set to true.
  -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
  -- Default: 0
  start_delay = 3000, -- 3 second delay

  -- Only attempt to install if 'debounce_hours' number of hours has
  -- elapsed since the last time Neovim was started. This stores a
  -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
  -- This is only relevant when you are using 'run_on_start'. It has no
  -- effect when running manually via ':MasonToolsInstall' etc....
  -- Default: nil
  debounce_hours = 5, -- at least 5 hours between attempts to install/update
})

-- この一連の記述で、mason.nvimでインストールしたLanguage Serverが自動的に個別にセットアップされ、利用可能になります
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers({
  function(server_name) -- default handler (optional)
    if server_name == "clangd" then
      capabilities.offsetEncoding = "utf-8"
    end
    require("lspconfig")[server_name].setup({
      on_attach = on_attach, --keyバインドなどの設定を登録
      capabilities = capabilities, --cmpを連携
      settings = settings,
    })
  end,
})

require("user.lsp.null-ls")
require("user.lsp.lspsaga")
