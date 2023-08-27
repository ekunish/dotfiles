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
    "pyright",
    "rust-analyzer",
    "tailwindcss-language-server",
    "yaml-language-server",
    "lua-language-server",
    "vim-language-server",
    "stylua",
    "shellcheck",
    "editorconfig-checker",
    "arduino-language-server",
    "docker-compose-language-service",
    "dockerfile-language-server",

    "typescript-language-server",
    -- "eslint-lsp",
    -- "prettier",

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
-- 補完プラグインであるcmp_nvim_lspをLSPと連携させています（後述）
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local default_on_attach = function(client, bufnr) end
local disable_formatting = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
end
local disable_diagnostics = {
  ["textDocument/publishDiagnostics"] = function() end,
}
local settings = {
  Lua = {
    diagnostics = { globals = { "vim" } },
  },
}
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers({
  function(server_name) -- default handler (optional)
    local on_attach = default_on_attach
    if server_name == "clangd" then
      capabilities.offsetEncoding = "utf-8"
    end
    lspconfig[server_name].setup({
      on_attach = on_attach, --keyバインドなどの設定を登録
      capabilities = capabilities, --cmpを連携
      settings = settings,
    })
    if server_name == "tsserver" then
      lspconfig[server_name].setup({
        on_attach = disable_formatting,
        capabilities = capabilities,
        settings = settings,
        handlers = disable_diagnostics,
      })
    end
  end,
})

require("user.lsp.null-ls")
