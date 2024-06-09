local wk = require("which-key")
-- As an example, we will create the following mappings:
--  * <leader>ff find files
--  * <leader>fr show recent files
--  * <leader>fb Foobar
-- we'll document:
--  * <leader>fn new file
--  * <leader>fe edit file
-- and hide <leader>1

wk.register({
    f = {
        name = "file",                                       -- optional group name
        f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
        F = { "<cmd>Telescope live_grep<cr>", "Live Grep" }, -- create a binding with label
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" }, -- additional options for creating the keymap
        -- n = { "New File" },                           -- just a label. don't create any mapping
        -- e = "Edit File",                              -- same as above
        -- ["1"] = "which_key_ignore",                   -- special label to hide it in the popup
        b = {
            function()
                print("bar")
            end,
            "Foobar",
        }, -- you can also pass functions!
    },
    l = {
        name = "lsp",
        g = { "<cmd>Lspsaga finder<cr>", "Finder" },
        a = { "<cmd>Lspsaga code_action<cr>", "Code Action" },
        d = { "<cmd>Lspsaga goto_definition<cr>", "Goto Definition" },
        D = { "<cmd>Lspsaga peek_definition<cr>", "Peek Definition" },
        f = { vim.lsp.buf.format, "Format" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        j = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Next Diagnostic" },
        k = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Prev Diagnostic" },
        q = { vim.diagnostic.setloclist, "Quickfix" },
        r = { "<cmd>Lspsaga rename<cr>", "Rename" },
        K = { "<cmd>Lspsaga hover_doc<cr>", "Show Hover" },
        R = { vim.lsp.buf.references, "Goto References" },
        s = { vim.lsp.buf.signature_help, "Signature Help" },
        o = { "<cmd>Lspsaga outline<cr>", "Show Outline" },
    },
    c = {
        name = "Copilot",
        a = { "<cmd>CopilotChat<cr>", "Open - CopilotChat" },
        b = { "<cmd>CopilotChatBuffer<cr>", "File - CopilotChat" },
        y = { "<cmd>CopilotChatYanked<cr>", "Yanked - CopilotChat" },
    },
    d = {
        name = "Debug",
        t = { "<cmd>DapToggleBreakpoint<cr>", "Toggle Breakpoint" },
        c = { "<cmd>DapContinue<cr>", "Continue" },
    },
    h = { "<cmd>noh<cr>", "Clear Highlight" },
    e = { "<cmd>Neotree toggle<cr>", "Neotree Toggle" },
    t = {
        name = "Terminal",
        o = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
        h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
        v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
    },
    M = { "<cmd>Mason<cr>", "Mason" },
    L = { "<cmd>Lazy<cr>", "Lazy" },
    P = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
}, { prefix = "<leader>" })

vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>")
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>")
vim.keymap.set("n", "<C-t>", "<cmd>Neotree toggle<cr>", {})
-- vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
-- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
-- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
-- vim.keymap.set('n', '<C-f>', require("telescope.builtin").find_files, {})
-- vim.keymap.set('n', '<leader>f', require("telescope.builtin").find_files, {})
-- vim.keymap.set('n', '<leader>F', require("telescope.builtin").live_grep, {})
