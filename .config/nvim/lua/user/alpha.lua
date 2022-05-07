local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
  -- [[                                                        ]],
  -- [[                   ▀████▀▄▄              ▄█             ]],
  -- [[                     █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█             ]],
  -- [[             ▄        █          ▀▀▀▀▄  ▄▀              ]],
  -- [[            ▄▀ ▀▄      ▀▄              ▀▄▀              ]],
  -- [[           ▄▀    █     █▀   ▄█▀▄      ▄█                ]],
  -- [[           ▀▄     ▀▄  █     ▀██▀     ██▄█               ]],
  -- [[            ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █              ]],
  -- [[             █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀              ]],
  -- [[            █   █  █      ▄▄           ▄▀               ]],
  -- [[                                                        ]],
  -- [[ ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗ ]],
  -- [[ ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║ ]],
  -- [[ ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║ ]],
  -- [[ ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║ ]],
  -- [[ ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║ ]],
  -- [[ ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝ ]],
  [[                                                        ]],
  [[                                                        ]],
  [[                                                        ]],
  [[                                                        ]],
  [[                                                        ]],
  [[ ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗ ]],
  [[ ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║ ]],
  [[ ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║ ]],
  [[ ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║ ]],
  [[ ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║ ]],
  [[ ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝ ]],
  [[                                                        ]],
  [[                                                        ]],
  [[                                                        ]],
  [[                                                        ]],
  [[                                                        ]],
}

dashboard.section.buttons.val = {
  dashboard.button("f", "📁 Find file", ":Telescope find_files <CR>"),
  dashboard.button("e", "🆕 New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("p", "🚧 Find project", ":Telescope projects <CR>"),
  dashboard.button("r", "⏱️  Recently used files", ":Telescope oldfiles <CR>"),
  dashboard.button("t", "📝 Find text", ":Telescope live_grep <CR>"),
  dashboard.button("c", "🔨 Configuration", ":e ~/.config/nvim/init.lua <CR>"),
  dashboard.button("q", "🚪 Quit Neovim", ":qa<CR>"),
  -- dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
  -- dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
  -- dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
  -- dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
  -- dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
  -- dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
  -- dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

local function footer()
  -- NOTE: requires the fortune-mod package to work
  -- local handle = io.popen("fortune")
  -- local fortune = handle:read("*a")
  -- handle:close()
  -- return fortune
  return "@ekunish"
end

math.randomseed(os.time())

local function pick_color()
  -- local colors = { "String", "Identifier", "Keyword", "Number" }
  local colors = { "Number" }
  return colors[math.random(#colors)]
end

dashboard.section.header.opts.hl = pick_color()

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Number" -- "Type"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)
