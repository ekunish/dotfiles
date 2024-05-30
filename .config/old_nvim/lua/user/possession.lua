local status_ok, possession = pcall(require, "possession")
if not status_ok then
  return
end

possession.setup({
  -- session_dir = (Path:new(vim.fn.stdpath("data")) / "possession"):absolute(),
  silent = false,
  load_silent = true,
  debug = false,
  logfile = false,
  prompt_no_cr = false,
  autosave = {
    current = false, -- or fun(name): boolean
    tmp = false, -- or fun(): boolean
    tmp_name = "tmp", -- or fun(): string
    on_load = true,
    on_quit = true,
  },
  commands = {
    save = "PossessionSave",
    load = "PossessionLoad",
    rename = "PossessionRename",
    close = "PossessionClose",
    delete = "PossessionDelete",
    show = "PossessionShow",
    list = "PossessionList",
    migrate = "PossessionMigrate",
  },
  hooks = {
    before_save = function(name)
      return {}
    end,
    after_save = function(name, user_data, aborted) end,
    before_load = function(name, user_data)
      return user_data
    end,
    after_load = function(name, user_data) end,
  },
  plugins = {
    close_windows = {
      hooks = { "before_save", "before_load" },
      preserve_layout = true, -- or fun(win): boolean
      match = {
        floating = true,
        buftype = {},
        filetype = {},
        custom = false, -- or fun(win): boolean
      },
    },
    delete_hidden_buffers = {
      hooks = {
        "before_load",
        vim.o.sessionoptions:match("buffer") and "before_save",
      },
      force = false, -- or fun(buf): boolean
    },
    nvim_tree = true,
    tabby = true,
    dap = true,
    delete_buffers = false,
  },
  telescope = {
    list = {
      default_action = "load",
      mappings = {
        save = { n = "<c-x>", i = "<c-x>" },
        load = { n = "<c-v>", i = "<c-v>" },
        delete = { n = "<c-t>", i = "<c-t>" },
        rename = { n = "<c-r>", i = "<c-r>" },
      },
    },
  },
})

local restart_cmd = nil

if vim.g.neovide then
  if vim.fn.has("wsl") == 1 then
    restart_cmd = "silent! !nohup neovide.exe --wsl &"
  else
    restart_cmd = "silent! !neovide.exe"
  end
elseif vim.g.fvim_loaded then
  if vim.fn.has("wsl") == 1 then
    restart_cmd = "silent! !nohup fvim.exe &"
  else
    restart_cmd = [=[silent! !powershell -Command "Start-Process -FilePath fvim.exe"]=]
  end
end

vim.api.nvim_create_user_command("Restart", function()
  if vim.fn.has("gui_running") then
    if restart_cmd == nil then
      vim.notify("Restart command not found", vim.log.levels.WARN)
    end
  end

  possession.session.save("restart", { no_confirm = true })
  vim.cmd([[silent! bufdo bwipeout]])

  vim.g.NVIM_RESTARTING = true

  if restart_cmd then
    vim.cmd(restart_cmd)
  end

  vim.cmd([[qa!]])
end, {})

vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    if vim.g.NVIM_RESTARTING then
      vim.g.NVIM_RESTARTING = false
      possession.session.load("restart")
      possession.session.delete("restart", { no_confirm = true })
      vim.opt.cmdheight = 1
    end
  end,
})
