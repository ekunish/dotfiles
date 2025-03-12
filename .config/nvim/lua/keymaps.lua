local wk = require("which-key")

wk.add({
  { "<leader>f", group = "file", icon = "📂" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", icon = "🔍" },
  { "<leader>fF", "<cmd>Telescope live_grep<cr>", desc = "Live Grep", icon = "🧲" },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File", icon = "📄" },
  { "<leader>fs", "<cmd>w<cr>", desc = "Save File", icon = "💾" },
  { "<leader>fb", function() print("bar") end, desc = "Foobar", icon = "🐧" },

  { "<leader>l", group = "lsp", icon = "🛠" },
  { "<leader>lg", "<cmd>Lspsaga finder<cr>", desc = "Finder", icon = "🔍" },
  { "<leader>la", "<cmd>Lspsaga code_action<cr>", desc = "Code Action", icon = "🛠" },
  { "<leader>ld", "<cmd>Lspsaga goto_definition<cr>", desc = "Goto Definition", icon = "📌" },
  { "<leader>lD", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition", icon = "👀" },
  { "<leader>lf", vim.lsp.buf.format, desc = "Format", icon = "📝" },
  { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info", icon = "ℹ️" },
  { "<leader>lj", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next Diagnostic", icon = "➡️" },
  { "<leader>lk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Prev Diagnostic", icon = "⬅️" },
  { "<leader>lq", vim.diagnostic.setloclist, desc = "Quickfix", icon = "🚑" },
  { "<leader>lr", "<cmd>Lspsaga rename<cr>", desc = "Rename", icon = "✏️" },
  { "<leader>lK", "<cmd>Lspsaga hover_doc<cr>", desc = "Show Hover", icon = "📖" },
  { "<leader>lR", vim.lsp.buf.references, desc = "Goto References", icon = "🔗" },
  { "<leader>ls", vim.lsp.buf.signature_help, desc = "Signature Help", icon = "✋" },
  { "<leader>lo", "<cmd>Lspsaga outline<cr>", desc = "Show Outline", icon = "🧾" },

  { "<leader>c", group = "Copilot", icon = "🤖" },
  { "<leader>ca", "<cmd>CopilotChat<cr>", desc = "Open - CopilotChat", icon = "💬" },
  { "<leader>cb", "<cmd>CopilotChatBuffer<cr>", desc = "File - CopilotChat", icon = "📝" },
  { "<leader>cy", "<cmd>CopilotChatYanked<cr>", desc = "Yanked - CopilotChat", icon = "📋" },

  { "<leader>d", group = "Debug", icon = "🐞" },
  { "<leader>dt", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint", icon = "⛔" },
  { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue", icon = "▶️" },

  { "<leader>h", "<cmd>noh<cr>", desc = "Clear Highlight", icon = "🌈" },
  { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Neotree Toggle", icon = "🌲" },

  { "<leader>t", group = "Terminal", icon = "📟" },
  { "<leader>to", "<cmd>ToggleTerm direction=float<cr>", desc = "Float", icon = "🔲" },
  { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal", icon = "⬇️" },
  { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical", icon = "➡️" },

  { "<leader>M", "<cmd>Mason<cr>", desc = "Mason", icon = "📦" },
  { "<leader>L", "<cmd>Lazy<cr>", desc = "Lazy", icon = "🐢" },
  { "<leader>P", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects", icon = "📂" },

  { "<leader>g", group = "Git", icon = "🌱" },
  { "<leader>gs", "<cmd>Git<cr>", desc = "Git Status", icon = "📊" },
  { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit", icon = "📝" },
  { "<leader>gp", "<cmd>Git push<cr>", desc = "Git Push", icon = "📤" },

  { "<leader>w", group = "Windows", icon = "🪟" },
  { "<leader>ws", "<cmd>split<cr>", desc = "Horizontal Split", icon = "➡️" },
  { "<leader>wv", "<cmd>vsplit<cr>", desc = "Vertical Split", icon = "⬇️" },
  { "<leader>wc", "<cmd>close<cr>", desc = "Close Window", icon = "❌" },
}, { mode = "n", prefix = "<leader>" })

-- wk.register({
--     f = {
--         name = "file",                                       -- optional group name
--         f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
--         F = { "<cmd>Telescope live_grep<cr>", "Live Grep" }, -- create a binding with label
--         r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" }, -- additional options for creating the keymap
--         -- n = { "New File" },                           -- just a label. don't create any mapping
--         -- e = "Edit File",                              -- same as above
--         -- ["1"] = "which_key_ignore",                   -- special label to hide it in the popup
--         b = {
--             function()
--                 print("bar")
--             end,
--             "Foobar",
--         }, -- you can also pass functions!
--     },
--     l = {
--         name = "lsp",
--         g = { "<cmd>Lspsaga finder<cr>", "Finder" },
--         a = { "<cmd>Lspsaga code_action<cr>", "Code Action" },
--         d = { "<cmd>Lspsaga goto_definition<cr>", "Goto Definition" },
--         D = { "<cmd>Lspsaga peek_definition<cr>", "Peek Definition" },
--         f = { vim.lsp.buf.format, "Format" },
--         i = { "<cmd>LspInfo<cr>", "Info" },
--         j = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Next Diagnostic" },
--         k = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Prev Diagnostic" },
--         q = { vim.diagnostic.setloclist, "Quickfix" },
--         r = { "<cmd>Lspsaga rename<cr>", "Rename" },
--         K = { "<cmd>Lspsaga hover_doc<cr>", "Show Hover" },
--         R = { vim.lsp.buf.references, "Goto References" },
--         s = { vim.lsp.buf.signature_help, "Signature Help" },
--         o = { "<cmd>Lspsaga outline<cr>", "Show Outline" },
--     },
--     c = {
--         name = "Copilot",
--         a = { "<cmd>CopilotChat<cr>", "Open - CopilotChat" },
--         b = { "<cmd>CopilotChatBuffer<cr>", "File - CopilotChat" },
--         y = { "<cmd>CopilotChatYanked<cr>", "Yanked - CopilotChat" },
--     },
--     d = {
--         name = "Debug",
--         t = { "<cmd>DapToggleBreakpoint<cr>", "Toggle Breakpoint" },
--         c = { "<cmd>DapContinue<cr>", "Continue" },
--     },
--     h = { "<cmd>noh<cr>", "Clear Highlight" },
--     e = { "<cmd>Neotree toggle<cr>", "Neotree Toggle" },
--     t = {
--         name = "Terminal",
--         o = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
--         h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
--         v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
--     },
--     M = { "<cmd>Mason<cr>", "Mason" },
--     L = { "<cmd>Lazy<cr>", "Lazy" },
--     P = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
-- }, { prefix = "<leader>" })

vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>")
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>")
vim.keymap.set("n", "<C-t>", "<cmd>Neotree toggle<cr>", {})

-- vim.keymap.set("n", "j", "gj")
-- vim.keymap.set("n", "k", "gk")
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true})
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true})

-- vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
-- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
-- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
-- vim.keymap.set('n', '<C-f>', require("telescope.builtin").find_files, {})
-- vim.keymap.set('n', '<leader>f', require("telescope.builtin").find_files, {})
-- vim.keymap.set('n', '<leader>F', require("telescope.builtin").live_grep, {})

-- place this in one of your configuration file(s)
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})
vim.keymap.set('', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})
