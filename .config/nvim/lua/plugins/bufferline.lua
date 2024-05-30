return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    after = "catppuccin",
    config = function()
        require("bufferline").setup({
            highlights = require("catppuccin.groups.integrations.bufferline").get(),
            options = {
                show_close_icon = true,
                diagnostics = "nvim_lsp",
                max_prefix_length = 8,
            },
        })
    end,
}
