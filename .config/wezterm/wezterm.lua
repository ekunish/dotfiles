local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action
local mux = wezterm.mux

config.color_scheme = 'Catppuccin Mocha'

-- ---------------------
-- フォント設定
-- ---------------------
config.font = wezterm.font('HackGen Console NF', { weight = 'Regular', italic = false })
config.font_size = 12.5

-- ---------------------
-- 基本設定
-- ---------------------
config.use_ime = true
config.audible_bell = 'Disabled'
config.adjust_window_size_when_changing_font_size = false
config.front_end = 'WebGpu'
config.initial_cols = 120
config.initial_rows = 28

-- ---------------------
-- 外観設定
-- ---------------------
config.window_background_opacity = 0.91
config.text_background_opacity = 1.0
config.macos_window_background_blur = 20
-- config.window_decorations = 'TITLE | RESIZE'
config.window_decorations = 'RESIZE'
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }

-- ---------------------
-- タブバー設定
-- ---------------------
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 64

-- ---------------------
-- ハイパーリンクルール
-- ---------------------
config.hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(config.hyperlink_rules, {
  regex = [[\b[tt](\d+)\b]],
  format = 'https://example.com/tasks/?t=$1',
})

table.insert(config.hyperlink_rules, {
  regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
  format = 'https://www.github.com/$1/$3',
})

-- ---------------------
-- 起動時にウィンドウを最大化
-- ---------------------
-- wezterm.on('gui-startup', function(cmd)
--   local tab, pane, window = mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)

-- ---------------------
-- ステータスバー（右: ワークスペース | CWD | キーテーブル | 日時）
-- ---------------------
local wifi_cache = { ssid = '', updated_at = 0 }
local WIFI_CACHE_SECS = 1800

local function get_wifi_ssid()
  local now = os.time()
  if now - wifi_cache.updated_at < WIFI_CACHE_SECS then
    return wifi_cache.ssid
  end
  local success, stdout = wezterm.run_child_process({ 'shortcuts', 'run', 'Get Wi-Fi SSID' })
  local result
  if not success then
    result = '󰤭 offline'
  else
    local ssid = stdout:gsub('%s+$', '')
    result = #ssid > 0 and ('󰤨 ' .. ssid) or '󰤭 offline'
  end
  wifi_cache.ssid = result
  wifi_cache.updated_at = now
  return result
end

local function get_battery_status()
  local success, stdout = wezterm.run_child_process({ 'pmset', '-g', 'batt' })
  if not success then return '' end
  local pct = stdout:match('(%d+)%%')
  if not pct then return '' end
  local n = tonumber(pct)
  local icon
  if n >= 80 then icon = '󰁹'
  elseif n >= 60 then icon = '󰂁'
  elseif n >= 40 then icon = '󰁿'
  elseif n >= 20 then icon = '󰁽'
  else icon = '󰁻'
  end
  if stdout:match('AC Power') then icon = '󰂄' end
  return icon .. ' ' .. pct .. '%'
end

wezterm.on('update-right-status', function(window, pane)
  local workspace = window:active_workspace()
  local date = wezterm.strftime('%m/%d %H:%M')
  local battery = get_battery_status()
  local wifi = get_wifi_ssid()

  -- アクティブなキーテーブル名を表示（モーダル操作のフィードバック）
  local key_table = window:active_key_table()
  local mode = key_table and (' ' .. key_table .. ' |') or ''

  window:set_right_status(wezterm.format({
    { Foreground = { Color = '#89b4fa' } },
    { Text = ' ' .. workspace .. ' ' },
    { Foreground = { Color = '#6c7086' } },
    { Text = '|' },
    { Foreground = { Color = '#f38ba8' } },
    { Text = mode },
    { Foreground = { Color = '#94e2d5' } },
    { Text = ' ' .. wifi .. ' ' },
    { Foreground = { Color = '#6c7086' } },
    { Text = '|' },
    { Foreground = { Color = '#a6e3a1' } },
    { Text = ' ' .. battery .. ' ' },
    { Foreground = { Color = '#6c7086' } },
    { Text = '|' },
    { Foreground = { Color = '#fab387' } },
    { Text = ' ' .. date .. ' ' },
  }))
end)

-- ---------------------
-- タブタイトルのカスタマイズ
-- ---------------------
local process_icons = {
  ['nvim'] = ' ',
  ['vim'] = ' ',
  ['zsh'] = ' ',
  ['bash'] = ' ',
  ['fish'] = ' ',
  ['node'] = ' ',
  ['python'] = ' ',
  ['python3'] = ' ',
  ['ruby'] = ' ',
  ['go'] = ' ',
  ['cargo'] = ' ',
  ['rustc'] = ' ',
  ['docker'] = ' ',
  ['git'] = ' ',
  ['lazygit'] = ' ',
  ['ssh'] = ' ',
  ['htop'] = '󰍛 ',
  ['btm'] = '󰍛 ',
  ['top'] = '󰍛 ',
  ['make'] = ' ',
  ['kubectl'] = '󱃾 ',
  ['lua'] = ' ',
}

local function get_process_name(pane)
  local name = pane.foreground_process_name or ''
  name = name:gsub('(.*/)(.*)', '%2')
  return (name:gsub('^%-', ''))
end

local function get_cwd_basename(pane)
  local cwd = pane.current_working_dir
  if not cwd then return '' end
  local path = cwd.file_path or tostring(cwd) or ''
  path = path:gsub('/$', '')
  local home = os.getenv('HOME') or ''
  if path == home then return '~' end
  return path:gsub('(.*/)(.*)', '%2')
end

-- ssh/mosh/et の argv から接続先ホスト名を抽出（user_vars.HOSTNAME が無い時の fallback）
local SSH_FLAGS_WITH_ARG = {
  ['-l']=true, ['-p']=true, ['-i']=true, ['-o']=true, ['-F']=true,
  ['-b']=true, ['-c']=true, ['-D']=true, ['-E']=true, ['-e']=true,
  ['-I']=true, ['-J']=true, ['-L']=true, ['-m']=true, ['-O']=true,
  ['-Q']=true, ['-R']=true, ['-S']=true, ['-W']=true, ['-w']=true,
  ['-B']=true,
}

local function parse_remote_host_from_argv(argv)
  if not argv or #argv < 2 then return nil end
  local skip = false
  for i = 2, #argv do
    local a = argv[i]
    if skip then
      skip = false
    elseif SSH_FLAGS_WITH_ARG[a] then
      skip = true
    elseif a:sub(1, 1) == '-' then
      -- 結合フラグ (-oX=Y) や短ブーリアン (-vvv) はスキップ
    else
      local h = a:match('([^@]+)$') or a           -- user@host → host
      -- IPv4 (+ optional :port) はそのまま返す
      local ipv4 = h:match('^(%d+%.%d+%.%d+%.%d+)')
      if ipv4 then return ipv4 end
      h = h:match('([^:]+)') or h                  -- host:port → host
      h = h:match('([^%.]+)') or h                 -- host.fqdn → host
      return h
    end
  end
  return nil
end

local function get_remote_host_via_argv(pane)
  local ok, mpane = pcall(mux.get_pane, pane.pane_id)
  if not ok or not mpane then return nil end
  local info = mpane:get_foreground_process_info()
  if not info or not info.argv then return nil end
  return parse_remote_host_from_argv(info.argv)
end

local TAB_WIDTH = 20

local function pad_or_truncate(str, width)
  local len = wezterm.column_width(str)
  if len >= width then
    return wezterm.truncate_right(str, width)
  end
  return str .. string.rep(' ', width - len)
end

wezterm.on('format-tab-title', function(tab)
  local pane = tab.active_pane
  local process = get_process_name(pane)
  local index = tab.tab_index + 1

  local icon = process_icons[process] or ' '

  -- カスタムタイトルがあればそちらを優先
  local title = tab.tab_title
  local label
  if title and #title > 0 then
    label = title
  else
    local shells = { zsh = true, bash = true, fish = true }
    local remote_cmds = { ssh = true, mosh = true, et = true }
    local local_host = wezterm.hostname():gsub('%..*', '')

    if shells[process] or process == 'tmux' then
      label = local_host .. ':' .. get_cwd_basename(pane)
    elseif remote_cmds[process] then
      label = get_remote_host_via_argv(pane) or process
    else
      label = process
    end
  end

  -- ズームインジケーター
  local zoom = ''
  for _, p in ipairs(tab.panes) do
    if p.is_zoomed then
      zoom = ' '
      break
    end
  end

  -- 未読出力インジケーター
  local unseen = ''
  if not tab.is_active then
    for _, p in ipairs(tab.panes) do
      if p.has_unseen_output then
        unseen = ' 󰈸'
        break
      end
    end
  end

  local content = string.format('%d:%s%s%s%s', index, icon, label, zoom, unseen)
  return ' ' .. pad_or_truncate(content, TAB_WIDTH) .. ' '
end)

-- ---------------------
-- Leader Key: Ctrl+a（tmux 互換）
-- Ctrl+Space は入力切り替えと競合するため避ける
-- readline の行頭移動は Ctrl+a 二度押しで送信可能
-- ---------------------
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

-- ---------------------
-- キーバインド
-- ---------------------
config.keys = {
  -- フォントサイズ変更
  { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },

  -- タブ操作
  { key = 't', mods = 'CMD', action = act.SpawnTab('CurrentPaneDomain') },
  { key = 'w', mods = 'CMD', action = act.CloseCurrentTab({ confirm = true }) },

  -- タブ切り替え (Cmd+数字)
  { key = '1', mods = 'CMD', action = act.ActivateTab(0) },
  { key = '2', mods = 'CMD', action = act.ActivateTab(1) },
  { key = '3', mods = 'CMD', action = act.ActivateTab(2) },
  { key = '4', mods = 'CMD', action = act.ActivateTab(3) },
  { key = '5', mods = 'CMD', action = act.ActivateTab(4) },
  { key = '6', mods = 'CMD', action = act.ActivateTab(5) },
  { key = '7', mods = 'CMD', action = act.ActivateTab(6) },
  { key = '8', mods = 'CMD', action = act.ActivateTab(7) },
  { key = '9', mods = 'CMD', action = act.ActivateTab(-1) },

  -- タブ移動
  { key = '[', mods = 'CMD', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'CMD', action = act.ActivateTabRelative(1) },

  -- ペイン分割（ダイレクト）
  { key = 'd', mods = 'CMD', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },

  -- ペイン移動（ダイレクト）
  { key = 'h', mods = 'CMD|ALT', action = act.ActivatePaneDirection('Left') },
  { key = 'l', mods = 'CMD|ALT', action = act.ActivatePaneDirection('Right') },
  { key = 'k', mods = 'CMD|ALT', action = act.ActivatePaneDirection('Up') },
  { key = 'j', mods = 'CMD|ALT', action = act.ActivatePaneDirection('Down') },

  -- ペインズーム（ダイレクト）
  { key = 'z', mods = 'CMD', action = act.TogglePaneZoomState },

  -- === Leader Key 操作 (Ctrl+a → ...) ===

  -- ペイン分割
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = '-', mods = 'LEADER', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },

  -- ペイン移動
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection('Left') },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection('Right') },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection('Up') },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection('Down') },

  -- ペインズーム
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

  -- ペインセレクト（ラベル表示で選択）
  { key = 's', mods = 'LEADER', action = act.PaneSelect },

  -- ペインスワップ
  { key = 'S', mods = 'LEADER|SHIFT', action = act.PaneSelect({ mode = 'SwapWithActive' }) },

  -- Quick Select（URL・パス・ハッシュ等をヒント付きコピー）
  { key = 'f', mods = 'LEADER', action = act.QuickSelect },

  -- Copy Mode（Vim スタイルのスクロールバック操作）
  { key = 'x', mods = 'LEADER', action = act.ActivateCopyMode },

  -- タブ操作
  { key = '.', mods = 'LEADER', action = act.PromptInputLine({
    description = wezterm.format({
      { Foreground = { Color = '#cba6f7' } },
      { Text = 'Tab name (empty to reset):' },
    }),
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  }) },
  { key = 'c', mods = 'LEADER', action = act.SpawnTab('CurrentPaneDomain') },
  { key = '[', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'q', mods = 'LEADER', action = act.CloseCurrentPane({ confirm = true }) },

  -- ワークスペース操作
  { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }) },
  { key = 'W', mods = 'LEADER|SHIFT', action = act.PromptInputLine({
    description = wezterm.format({
      { Foreground = { Color = '#cba6f7' } },
      { Text = 'New workspace name:' },
    }),
    action = wezterm.action_callback(function(window, pane, line)
      if line and #line > 0 then
        window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
      end
    end),
  }) },
  { key = ',', mods = 'LEADER', action = act.PromptInputLine({
    description = wezterm.format({
      { Foreground = { Color = '#cba6f7' } },
      { Text = 'Rename workspace:' },
    }),
    action = wezterm.action_callback(function(window, pane, line)
      if line and #line > 0 then
        mux.rename_workspace(window:active_workspace(), line)
      end
    end),
  }) },
  { key = 'n', mods = 'LEADER', action = act.SwitchWorkspaceRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.SwitchWorkspaceRelative(-1) },

  -- リサイズモードに入る
  { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable({ name = 'resize_pane', one_shot = false }) },

  -- Ctrl+a を二度押しでアプリに送信（readline の行頭移動等）
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey({ key = 'a', mods = 'CTRL' }) },
}

-- ---------------------
-- Key Tables（モーダルキーバインド）
-- ---------------------
config.key_tables = {
  -- リサイズモード: Leader + r で入り、Escape/Enter で抜ける
  -- ステータスバーに "resize_pane" と表示される
  resize_pane = {
    { key = 'h', action = act.AdjustPaneSize({ 'Left', 2 }) },
    { key = 'j', action = act.AdjustPaneSize({ 'Down', 2 }) },
    { key = 'k', action = act.AdjustPaneSize({ 'Up', 2 }) },
    { key = 'l', action = act.AdjustPaneSize({ 'Right', 2 }) },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'Enter', action = 'PopKeyTable' },
  },
}

return config
