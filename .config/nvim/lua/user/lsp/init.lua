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
    "yaml-language-server",
    "lua-language-server",
    "vim-language-server",
    "stylua",
    -- "shellcheck",
    "editorconfig-checker",
    "arduino-language-server",
    "docker-compose-language-service",
    "dockerfile-language-server",

    "typescript-language-server",
    "tailwindcss",

    "eslint-lsp",
    "prettier",

    "matlab_ls",

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

local lspconfig = require("lspconfig")
lspconfig.glsl_analyzer.setup({})

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

require("lspconfig.ui.windows").default_options.border = "rounded"

local default_on_attach = function(client, bufnr) end
local disable_formatting = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
end
local disable_diagnostics = {
  ["textDocument/publishDiagnostics"] = function() end,
}

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers({
  function(server_name) -- default handler (optional)
    local on_attach = default_on_attach
    if server_name == "clangd" then
      capabilities.offsetEncoding = "utf-8"
    elseif server_name == "tsserver" then
      lspconfig[server_name].setup({
        on_attach = disable_formatting,
        capabilities = capabilities,
        handlers = disable_diagnostics,
      })
    elseif server_name == "tailwindcss" then
      lspconfig[server_name].setup({
        on_attach = disable_formatting,
        capabilities = capabilities,
        filetypes = { "typescriptreact", "css", "html" },
      })
    elseif server_name == "bashls" then
      lspconfig[server_name].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "zsh", "bash", "sh" },
      })
    elseif server_name == "beautysh" then
      lspconfig[server_name].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "zsh", "bash", "sh" },
      })
    elseif server_name == "lua_ls" then
      lspconfig[server_name].setup({
        on_attach = on_attach, --keyバインドなどの設定を登録
        capabilities = capabilities, --cmpを連携
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
    elseif server_name == "glsl_analyzer" then
      lspconfig[server_name].setup({
        on_attach = on_attach, --keyバインドなどの設定を登録
        capabilities = capabilities, --cmpを連携
        filetypes = { "glsl" },
      })
    elseif server_name == "pyright" then
      capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
      lspconfig[server_name].setup({
        on_attach = on_attach, --keyバインドなどの設定を登録
        capabilities = capabilities, --cmpを連携
        filetypes = { "python" },
      })
    elseif server_name == "matlab_ls" then
      lspconfig[server_name].setup({
        on_attach = on_attach, --keyバインドなどの設定を登録
        capabilities = capabilities, --cmpを連携
        filetypes = { "matlab" },
        -- single_file_support = true,
      })
    else
      lspconfig[server_name].setup({
        on_attach = on_attach, --keyバインドなどの設定を登録
        capabilities = capabilities, --cmpを連携
        -- settings = settings,
      })
    end
  end,
})

require("user.lsp.null-ls")
