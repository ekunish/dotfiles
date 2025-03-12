return {
    -- "github/copilot.vim",
    -- lazy = false,
    -- config = function()
    --     vim.g.copilot_no_tab_map = true
    -- end

    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    lazy = false,
    config = function()
	vim.g.copilot_no_tab_map = true
        -- require("copilot").setup({
        --     suggestion = { enabled = false },
        --     panel = { enabled = false },
        -- })
    end,
}
