local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = false,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width,
}

-- local mode = {
--   "mode",
--   fmt = function(str)
--     return "-- " .. str .. " --"
--   end,
-- }
--
-- local filetype = {
--   "filetype",
--   icons_enabled = false,
--   icon = nil,
-- }
--
local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}
--
-- local location = {
--   "location",
--   padding = 0,
-- }
--
-- -- cool function for progress
-- local progress = {
--   function()
--     local current_line = vim.fn.line(".")
--     local total_lines = vim.fn.line("$")
--     local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
--     local line_ratio = current_line / total_lines
--     local index = math.ceil(line_ratio * #chars)
--     return chars[index]
--   end,
--   -- padding = { left = 0, right = 0},
--   cond = nil
-- }
--
-- local spaces = function()
--   return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
-- end
--
-- lualine.setup({
--   options = {
--     icons_enabled = true,
--     theme = "auto",
--     component_separators = { left = "", right = "" },
--     section_separators = { left = "", right = "" },
--     disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
--     always_divide_middle = true,
--   },
--   sections = {
--     lualine_a = { branch, diagnostics },
--     lualine_b = { mode },
--     lualine_c = {},
--     -- lualine_x = { "encoding", "fileformat", "filetype" },
--     lualine_x = { diff, spaces, "encoding", filetype },
--     lualine_y = { location },
--     lualine_z = { progress },
--   },
--   inactive_sections = {
--     lualine_a = {},
--     lualine_b = {},
--     lualine_c = { "filename" },
--     lualine_x = { "location" },
--     lualine_y = {},
--     lualine_z = {},
--   },
--   tabline = {},
--   extensions = {},
-- })
--


-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
local colors = {
  blue   = '#6272a4',
  cyan   = '#8be9fd',
  black  = '#282a36',
  white  = '#f8f8f2',
  red    = '#ff5555',
  violet = '#bd93f9',
  grey   = '#44475a',
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.black, bg = colors.black },
  },

  insert = { a = { fg = colors.white, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.black, bg = colors.black },
  },
}

lualine.setup({
  options = {
    theme = bubbles_theme,
    component_separators = "|",
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
  },
  sections = {
    lualine_a = {
      { "mode", separator = { left = "" }, right_padding = 2 },
    },
    lualine_b = { "filename", branch, diagnostics, diff },
    lualine_c = { "fileformat" },
    lualine_x = {},
    lualine_y = { "filetype", "progress" },
    lualine_z = {
      { "location", separator = { right = "" }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { "filename", "branch" },
    lualine_b = { "fileformat" },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { "filetype", "progress" },
    lualine_z = { "location" },
  },
  tabline = {},
  extensions = {},
})
