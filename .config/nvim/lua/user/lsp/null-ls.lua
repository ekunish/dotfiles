local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local completions = null_ls.builtins.completion
-- local completion = null_ls.builtins.completion
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end,

  debug = false,
  sources = {
    completions.spell,
    formatting.deno_fmt.with({
      condition = function(utils)
        return not (
          utils.has_file({
            ".prettierrc",
            ".prettierrc.js",
            ".prettierrc.json",
            ".prettier.config.js",
            "deno.json",
            "deno.jsonc",
          })
        )
      end,
    }),
    formatting.prettier.with({
      condition = function(utils)
        return utils.has_file({
          ".prettierrc",
          ".prettierrc.js",
          ".prettierrc.json",
          ".prettier.config.js",
          ".prettierrc.json",
          " .prettierignore",
        })
      end,
      prefer_local = "node_modules/.bin",
    }),
    formatting.black.with({ extra_args = { "--fast" } }),
    formatting.stylua.with({
      extra_args = { "--config-path", vim.fn.expand("~/.config/nvim/lua/user/lsp/settings/stylua.toml") },
    }),
    formatting.clang_format,

    diagnostics.eslint.with({
      prefer_local = "node_modules/.bin",
    }),

    formatting.beautysh,
  },
})
