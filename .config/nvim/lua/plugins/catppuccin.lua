return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "auto", -- latte, frappe, macchiato, mocha
            background = {    -- :h background
                light = "latte",
                dark = "macchiato",
            },
            transparent_background = true, -- disables setting the background color.
            show_end_of_buffer = true,     -- shows the '~' characters after the end of buffers
            term_colors = true,            -- sets terminal colors (e.g. `g:terminal_color_0`)
            dim_inactive = {
                enabled = false,           -- dims the background color of inactive window
                shade = "dark",
                percentage = 0.15,         -- percentage of the shade to apply to the inactive window
            },
            no_italic = false,             -- Force no italic
            no_bold = false,               -- Force no bold
            no_underline = false,          -- Force no underline
            styles = {                     -- Handles the styles of general hi groups (see `:h highlight-args`):
                comments = { "italic" },   -- Change the style of comments
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
                -- miscs = {}, -- Uncomment to turn off hard-coded styles
            },
            color_overrides = {},
            custom_highlights = {},
            default_integrations = true,
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                notify = true,
                mini = {
                    enabled = true,
                    indentscope_color = "",
                },
                mason = true,
                neotree = true,
                noice = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                        ok = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                        ok = { "underline" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                },
                telescope = {
                    enabled = true,
                    -- style = "nvchad"
                }
                -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            },
        })

        -- setup must be called before loading
        vim.cmd([[
            try
                colorscheme catppuccin-macchiato
                hi CursorLine guibg=none
            catch /^Vim\%((\a\+)\)\=:E185/
                colorscheme default
                set background=dark
                endtry
        ]])
    end,
}
