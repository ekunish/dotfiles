local status_ok, saga = pcall(require, "lspsaga")
if not status_ok then
  return
end

--use default config
saga.setup({
  preview = {
    lines_above = 0,
    lines_below = 10,
  },
  scroll_preview = {
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  request_timeout = 2000,
  ui = {
    -- currently only round theme
    theme = "round",
    -- this option only work in neovim 0.9
    title = true,
    -- border type can be single,double,rounded,solid,shadow.
    border = "solid",
    winblend = 0,
    expand = "",
    collapse = "",
    preview = " ",
    code_action = "💡",
    diagnostic = "🐞",
    incoming = " ",
    outgoing = " ",
    colors = {
      --float window normal background color
      normal_bg = "#1c1c19",
      --title background color
      title_bg = "#afd700",
      red = "#e95678",
      magenta = "#b33076",
      orange = "#FF8700",
      yellow = "#f7bb3b",
      green = "#afd700",
      cyan = "#36d0e0",
      blue = "#61afef",
      purple = "#CBA6F7",
      white = "#d1d4cf",
      black = "#1c1c19",
    },
    kind = {},
  },
})
