return {
    { "hrsh7th/cmp-nvim-lsp", },
    { "hrsh7th/cmp-emoji",                    event = 'InsertEnter' },
    { 'hrsh7th/nvim-cmp', },
    { 'hrsh7th/cmp-nvim-lsp',                 event = 'InsertEnter' },
    { 'hrsh7th/cmp-buffer',                   event = 'InsertEnter' },
    { 'hrsh7th/cmp-path',                     event = 'InsertEnter' },
    { 'hrsh7th/cmp-cmdline',                  event = 'ModeChanged' }, --これだけは'ModeChanged'でなければまともに動かなかった。
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
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-i>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
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
                    -- ["<S-Tab>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_prev_item()
                    --     elseif luasnip.jumpable(-1) then
                    --         luasnip.jump(-1)
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol',
                        maxwidth = 50,
                        ellipsis_char = '...',
                    })
                },

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    -- { name = 'vsnip' }, -- For vsnip users.
                    { name = "luasnip" }, -- For luasnip users.
                    -- { name = 'ultisnips' }, -- For ultisnips users.
                    -- { name = 'snippy' }, -- For snippy users.
                    { name = 'path' },  -- For path source.
                    { name = 'emoji' }, -- For path source.
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'calc' },
                    { name = "buffer",                 keyword_length = 2 },
                })
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
                    { name = 'cmdline', keyword_length = 2 }
                })
            })
        end,
    },
}
