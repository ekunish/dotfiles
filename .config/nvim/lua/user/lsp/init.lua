local on_attach = function(client, bufnr)
  -- LSPが持つフォーマット機能を無効化する
  -- →例えばtsserverはデフォルトでフォーマット機能を提供しますが、利用したくない場合はコメントアウトを解除してください
  client.server_capabilities.documentFormattingProvider = false

  -- local set = vim.keymap.set
  -- set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  -- set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  -- set("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  -- set("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  -- set("n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  -- set("n", "ma", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  -- set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  -- set("n", "<space>d", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
  -- set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
  -- set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
end

-- 補完プラグインであるcmp_nvim_lspをLSPと連携させています（後述）
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local settings = {
  Lua = {
    diagnostics = { globals = { "vim" } },
  },
}

-- この一連の記述で、mason.nvimでインストールしたLanguage Serverが自動的に個別にセットアップされ、利用可能になります
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers({
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup({
      on_attach = on_attach, --keyバインドなどの設定を登録
      capabilities = capabilities, --cmpを連携
      settings = settings,
    })
  end,
})

-- local status_ok, _ = pcall(require, "lspconfig")
-- if not status_ok then
--   return
-- end

-- require "user.lsp.lsp-installer"
-- require("user.lsp.handlers").setup()
require("user.lsp.null-ls")
require("user.lsp.lspsaga")
