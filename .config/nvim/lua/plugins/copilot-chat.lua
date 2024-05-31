return {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
        { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
        { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    opts = {
        prompts = {
            -- Code related prompts
            Explain = "Please explain how the following code works in Japanese.",
            Review = "Please review the following code and provide suggestions for improvement.",
            Tests = "Please explain how the selected code works, then generate unit tests for it.",
            Refactor = "Please refactor the following code to improve its clarity and readability.",
            FixCode = "Please fix the following code to make it work as intended.",
            FixError = "Please explain the error in the following text and provide a solution.",
            BetterNamings = "Please provide better names for the following variables and functions.",
            Documentation = "Please provide documentation for the following code.",
            SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
            SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
            -- Text related prompts
            Summarize = "Please summarize the following text.",
            Spelling = "Please correct any grammar and spelling errors in the following text.",
            Wording = "Please improve the grammar and wording of the following text.",
            Concise = "Please rewrite the following text to make it more concise.",
        },
        mappings = {
            complete = {
                detail = "Use @<Tab> or /<Tab> for options.",
                insert = "<Tab>",
            },
            -- Close the chat
            close = {
                normal = "q",
                insert = "<C-c>",
            },
            -- Reset the chat buffer
            reset = {
                normal = "<C-x>",
                insert = "<C-x>",
            },
            -- Submit the prompt to Copilot
            submit_prompt = {
                normal = "<CR>",
                insert = "<C-CR>",
            },
            -- Accept the diff
            accept_diff = {
                normal = "<C-y>",
                insert = "<C-y>",
            },
            -- Yank the diff in the response to register
            yank_diff = {
                normal = "rry",
            },
            -- Show the diff
            show_diff = {
                normal = "rmd",
            },
            -- Show the prompt
            show_system_prompt = {
                normal = "rmp",
            },
            -- Show the user selection
            show_user_selection = {
                normal = "rms",
            },
        },
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
        require("CopilotChat.integrations.cmp").setup()
        local chat = require("CopilotChat")
        local select = require("CopilotChat.select")
        chat.setup(opts)

        vim.api.nvim_create_user_command("CopilotChatYanked", function(args)
            chat.ask(args.args, { selection = select.visual })
        end, { nargs = "*", range = true })

        vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
            chat.ask(args.args, { selection = select.buffer })
        end, { nargs = "*", range = true })

        vim.api.nvim_create_user_command("CopilotChatHelpActions", function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end, { nargs = "*", range = true })

        vim.api.nvim_create_user_command("CopilotChatPrompts", function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end, { nargs = "*", range = true })

        -- Custom buffer for CopilotChat
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "copilot-*",
            callback = function()
                vim.opt_local.relativenumber = true
                vim.opt_local.number = true

                -- Get current filetype and set it to markdown if the current filetype is copilot-chat
                local ft = vim.bo.filetype
                if ft == "copilot-chat" then
                    vim.bo.filetype = "markdown"
                end
            end,
        })
    end,
}
