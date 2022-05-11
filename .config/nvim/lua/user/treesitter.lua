local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup({
  -- ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "" }, -- List of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  autotag = { enable = true },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
    -- config = {
    --   javascript = {
    --     __default = "// %s",
    --     jsx_element = "{/* %s */}",
    --     jsx_fragment = "{/* %s */}",
    --     jsx_attribute = "// %s",
    --     comment = "// %s",
    --   },
    --   typescript = {
    --     __default = "// %s",
    --     tsx_element = "{/* %s */}",
    --     tsx_fragment = "{/* %s */}",
    --     tsx_attribute = "// %s",
    --     comment = "// %s",
    --   },
    -- },
  },
})
