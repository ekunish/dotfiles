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
      prefer_local = "node_modules/.bin", --プロジェクトローカルがある場合はそれを利用
    }),
  },
})
