return {
    { 'hrsh7th/nvim-cmp',                     event = 'InsertEnter' },
    { "hrsh7th/cmp-nvim-lsp",                 event = 'InsertEnter' },
    { "hrsh7th/cmp-nvim-lua",                 event = 'InsertEnter' },
    { "hrsh7th/cmp-emoji",                    event = 'InsertEnter' },
    { 'hrsh7th/cmp-nvim-lsp',                 event = 'InsertEnter' },
    { 'hrsh7th/cmp-buffer',                   event = 'InsertEnter' },
    { 'hrsh7th/cmp-path',                     event = 'InsertEnter' },
    -- { 'hrsh7th/cmp-copilot',                  event = 'InsertEnter' },
    { "zbirenbaum/copilot-cmp",               lazy = false},
    { 'hrsh7th/cmp-cmdline',                  event = 'ModeChanged' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help',  event = 'InsertEnter' },
    { 'hrsh7th/cmp-nvim-lsp-document-symbol', event = 'InsertEnter' },
    { 'hrsh7th/cmp-calc',                     event = 'InsertEnter' },
    { 'onsails/lspkind.nvim',                 event = 'InsertEnter' },
    { 'rafamadriz/friendly-snippets',         event = 'InsertEnter' },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require('lspkind')
            require("luasnip.loaders.from_vscode").lazy_load()

            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local icons = require("icons")
            require("copilot_cmp").setup()

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    -- ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    -- ["<C-i>"] = cmp.mapping.complete(),
                    -- ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),

                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        vim_item.kind = icons.kind[vim_item.kind]
                        vim_item.menu = ({
                            nvim_lsp = "",
                            nvim_lua = "",
                            luasnip = "",
                            buffer = "",
                            path = "",
                            emoji = "",
                            copilot = "",
                        })[entry.source.name]

                        if entry.source.name == "emoji" then
                            vim_item.kind = icons.misc.Smiley
                            vim_item.kind_hl_group = "CmpItemKindEmoji"
                        end

                        if entry.source.name == "cmp_tabnine" then
                            vim_item.kind = icons.misc.Robot
                            vim_item.kind_hl_group = "CmpItemKindTabnine"
                        end

                        return vim_item
                    end,
                },


                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    -- { name = 'vsnip' }, -- For vsnip users.
                    { name = "luasnip" }, -- For luasnip users.
                    -- { name = 'ultisnips' }, -- For ultisnips users.
                    -- { name = 'snippy' }, -- For snippy users.
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'path' },  -- For path source.
                    { name = 'emoji' }, -- For path source.
                    { name = 'calc' },
                    { name = 'copilot'},
                    { name = "buffer",                 keyword_length = 2 },
                }),

                window = {
                    -- completion = cmp.config.window.bordered(),
                    completion = {
                        border = "rounded",
                        scrollbar = false
                    },
                    -- documentation = cmp.config.window.bordered(),
                    documentation = {
                        border = "rounded"
                    }

                },

            })

            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp_document_symbol' }
                }, {
                    { name = 'buffer' }
                })
            })

            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline', keyword_length = 1 }
                })
            })
        end,
    },
}
