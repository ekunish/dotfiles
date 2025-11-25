return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "catppuccin/nvim",
    },
    config = function()
        local highlights = {}
        local ok, catppuccin_bufferline = pcall(require, "catppuccin.groups.integrations.bufferline")
        if ok then
            highlights = catppuccin_bufferline.get()
        end

        require("bufferline").setup({
            highlights = highlights,
            options = {
                show_close_icon = true,
                diagnostics = "nvim_lsp",
                max_prefix_length = 8,
            },
        })
    end,
}
