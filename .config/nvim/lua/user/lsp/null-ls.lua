local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
-- local completion = null_ls.builtins.completion

null_ls.setup({
  debug = false,
  sources = {
    -- formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
    null_ls.builtins.formatting.deno_fmt.with({
      condition = function(utils)
        return not (utils.has_file({ ".prettierrc", ".prettierrc.js", "deno.json", "deno.jsonc" }))
      end,
    }),
    null_ls.builtins.formatting.prettier.with({
      condition = function(utils)
        return utils.has_file({ ".prettierrc", ".prettierrc.js" })
      end,
      prefer_local = "node_modules/.bin",
    }),
    formatting.black.with({ extra_args = { "--fast" } }),
    formatting.stylua.with({
      extra_args = { "--config-path", vim.fn.expand("~/.config/nvim/lua/user/lsp/settings/stylua.toml") },
    }),
    -- diagnostics.eslint,
    -- completion.spell,
  },
})
