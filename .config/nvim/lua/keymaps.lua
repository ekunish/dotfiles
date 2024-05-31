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
        name = "file",                                             -- optional group name
        f = { "<cmd>Telescope find_files<cr>", "Find File" },      -- create a binding with label
        F = { "<cmd>Telescope live_grep<cr>", "Live Grep" },       -- create a binding with label
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" }, -- additional options for creating the keymap
        -- n = { "New File" },                           -- just a label. don't create any mapping
        -- e = "Edit File",                              -- same as above
        -- ["1"] = "which_key_ignore",                   -- special label to hide it in the popup
        b = { function() print("bar") end, "Foobar" } -- you can also pass functions!
    },
    l = {
        name = "lsp",
        d = { vim.lsp.buf.definition, "Goto Definition" },
        D = { vim.lsp.buf.declaration, "Goto Declaration" },
        k = { vim.lsp.buf.hover, "Show Hover" },
        r = { vim.lsp.buf.references, "Goto References" },
        i = { vim.lsp.buf.implementation, "Goto Implementation" },
        h = { vim.lsp.buf.hover, "Show Hover" },
        a = { vim.lsp.buf.code_action, "Code Action" },
        f = { vim.lsp.buf.format, "Format" },
        s = { vim.lsp.buf.signature_help, "Signature Help" },
        R = { vim.lsp.buf.rename, "Rename" },
        x = { vim.lsp.stop_client(vim.lsp.get_active_clients), "Stop LSP" },
        -- ["1"] = "which_key_ignore",
    },
    c = {
        name = "Copilot",
        a = {"<cmd>CopilotChat<cr>", "Open - CopilotChat"},
        b = {"<cmd>CopilotChatBuffer<cr>", "File - CopilotChat"},
        y = {"<cmd>CopilotChatYanked<cr>", "Yanked - CopilotChat"},
    },
    h = { "<cmd>noh<cr>", "Clear Highlight" },
    t = { "<cmd>Neotree toggle<cr>", "Neotree Toggle" },
    m = { "<cmd>Mason<cr>", "Mason" },
    p = { "<cmd>Lazy<cr>", "Lazy" },
}, { prefix = "<leader>" })

-- vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.keymap.set("n", "<S-l>", "<CMD>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-h>", "<CMD>BufferLineCyclePrev<CR>")
vim.keymap.set('n', '<C-t>', ':Neotree toggle<CR>', {})
-- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
-- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
-- vim.keymap.set('n', '<C-f>', require("telescope.builtin").find_files, {})
-- vim.keymap.set('n', '<leader>f', require("telescope.builtin").find_files, {})
-- vim.keymap.set('n', '<leader>F', require("telescope.builtin").live_grep, {})
