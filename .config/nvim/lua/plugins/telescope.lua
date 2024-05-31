return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local icons = require("icons")
            local actions = require("telescope.actions")
            require("telescope").setup({
                defaults = {
                    prompt_prefix = icons.ui.Telescope .. " ",
                    selection_caret = icons.ui.Forward .. " ",
                    entry_prefix = "   ",
                    initial_mode = "insert",
                    selection_strategy = "reset",
                    path_display = { "smart" },
                    color_devicons = true,
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--glob=!.git/",
                    },

                    mappings = {
                        i = {
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,

                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                        n = {
                            ["<esc>"] = actions.close,
                            ["j"] = actions.move_selection_next,
                            ["k"] = actions.move_selection_previous,
                            ["q"] = actions.close,
                        },
                    },
                },
                pickers = {
                    live_grep = {
                        theme = "dropdown",
                    },

                    grep_string = {
                        theme = "dropdown",
                    },

                    find_files = {
                        theme = "dropdown",
                        previewer = false,
                    },

                    buffers = {
                        theme = "dropdown",
                        previewer = false,
                        initial_mode = "normal",
                        mappings = {
                            i = {
                                ["<C-d>"] = actions.delete_buffer,
                            },
                            n = {
                                ["dd"] = actions.delete_buffer,
                            },
                        },
                    },

                    planets = {
                        show_pluto = true,
                        show_moon = true,
                    },

                    colorscheme = {
                        enable_preview = true,
                    },

                    lsp_references = {
                        theme = "dropdown",
                        initial_mode = "normal",
                    },

                    lsp_definitions = {
                        theme = "dropdown",
                        initial_mode = "normal",
                    },

                    lsp_declarations = {
                        theme = "dropdown",
                        initial_mode = "normal",
                    },

                    lsp_implementations = {
                        theme = "dropdown",
                        initial_mode = "normal",
                    },
                },
            })
        end
    }
}
