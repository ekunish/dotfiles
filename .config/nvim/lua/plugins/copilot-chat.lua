return {
    "CopilotC-Nvim/CopilotChat.nvim",
    build = "make tiktoken", -- Only on MacOS or Linux
    dependencies = {
        { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
        { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    opts = {
        window = {
            layout = 'float',       -- 'vertical', 'horizontal', 'float', 'replace'
            width = 0.8,            -- fractional width of parent, or absolute width in columns when > 1
            height = 0.8,           -- fractional height of parent, or absolute height in rows when > 1
            -- Options below only apply to floating windows
            relative = 'editor',    -- 'editor', 'win', 'cursor', 'mouse'
            border = 'rounded',     -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
            row = nil,              -- row position of the window, default is centered
            col = nil,              -- column position of the window, default is centered
            title = 'Copilot Chat', -- title of chat window
            footer = nil,           -- footer of chat window
            zindex = 1,             -- determines if window is on top or below other floating windows
        },

    },
    config = function(_, opts)
        local chat = require("CopilotChat")
        chat.setup(opts)
    end,
}
