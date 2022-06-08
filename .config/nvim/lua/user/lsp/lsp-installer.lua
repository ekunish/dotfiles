local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

-- -- Register a handler that will be called for all installed servers.
-- -- Alternatively, you may also register handlers on specific server instances instead (see example below).
-- lsp_installer.on_server_ready(function(server)
local opts = {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}
--
--   if server.name == "jsonls" then
--     local jsonls_opts = require("user.lsp.settings.jsonls")
--     opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
--   end
--
-- if server.name == "sumneko_lua" then
--   local sumneko_opts = require("user.lsp.settings.sumneko_lua")
--   opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
-- end
--
--   if server.name == "tsserver" or server.name == "eslint" then
--     local tsserver_opts = require("user.lsp.settings.tsserver")
--     opts = vim.tbl_deep_extend("force", tsserver_opts, opts)
--   end
--
--   -- This setup() function is exactly the same as lspconfig's setup function.
--   -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--   server:setup(opts)
-- end)

require("nvim-lsp-installer").setup({})
local lspconfig = require("lspconfig")

local sumneko_opts = require("user.lsp.settings.sumneko_lua")
sumneko_opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
lspconfig.sumneko_lua.setup(sumneko_opts)

lspconfig.eslint.setup(opts)
lspconfig.tsserver.setup(opts, {
  solargraph = {
    diagnostics = false,
  },
})
lspconfig.intelephense.setup(opts)
lspconfig.tailwindcss.setup({
  opts,
  -- cmd = { "yarn", "tailwindcss-language-server", "--stdio" },
})
lspconfig.zk.setup(opts)

local schemas = require("user.lsp.settings.jsonls")
lspconfig.jsonls.setup(opts, {
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      schemas = schemas,
    },
  },
})
