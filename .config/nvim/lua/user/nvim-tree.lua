-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
-- vim.g.nvim_tree_icons = {
--   default = "",
--   symlink = "",
--   git = {
--     unstaged = "",
--     staged = "S",
--     unmerged = "",
--     renamed = "➜",
--     deleted = "",
--     untracked = "U",
--     ignored = "◌",
--   },
--   folder = {
--     default = "",
--     open = "",
--     empty = "",
--     empty_open = "",
--     symlink = "",
--   },
-- }

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup({
  disable_netrw = true,
  hijack_netrw = true,
  -- open_on_setup = false,
  -- ignore_ft_on_setup = {
  --   "startify",
  --   "dashboard",
  --   "alpha",
  -- },
  -- auto_close = true,
  open_on_tab = false,
  hijack_cursor = true,
  update_cwd = true,
  -- update_to_buf_dir = {
  --   enable = true,
  --   auto_open = true,
  -- },
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  filters = {
    dotfiles = false,
    custom = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  -- view = {
  --   width = 30,
  --   -- height = 30,
  --   hide_root_folder = false,
  --   side = "left",
  --   -- auto_resize = true,
  --   mappings = {
  --     custom_only = false,
  --     list = {
  --       { key = { "<CR>", "o" }, cb = tree_cb("edit") },
  --       { key = "h", cb = tree_cb("close_node") },
  --       { key = "v", cb = tree_cb("vsplit") },
  --     },
  --   },
  --   number = false,
  --   relativenumber = false,
  -- },
  -- trash = {
  --   cmd = "trash",
  --   require_confirm = true,
  -- },
  -- quit_on_open = 0,
  -- git_hl = 1,
  -- disable_window_picker = 0,
  -- root_folder_modifier = ":t",
  -- show_icons = {
  --   -- git = 1,
  --   folders = 1,
  --   files = 1,
  --   folder_arrows = 1,
  --   tree_width = 30,
  -- },
})


vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local invalid_win = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then
        table.insert(invalid_win, w)
      end
    end
    if #invalid_win == #wins - 1 then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
    end
  end
})
