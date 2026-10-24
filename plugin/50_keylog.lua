-- ┌───────────────┐
-- │ Keystroke log │
-- └───────────────┘
--
-- Records how you use Neovim so it can later be reviewed (by you or an AI) to
-- find inefficient habits. Logs go to daily files in `stdpath('state')/keylog/`.
-- Example usage:
-- - `<Leader>ok` - open today's log
-- - `<Leader>oK` - pick among all logs
-- - `:KeylogToggle` - pause/resume recording (state is not persisted)
--
-- Format: one line per uninterrupted run of keys in a single mode:
--   HH:MM:SS <Tab> filetype <Tab> mode <Tab> keys
-- Privacy:
-- - Insert mode text is NOT recorded. Printable characters are collapsed into
--   `«N chars»`; only special keys (like `<BS>`, `<C-w>`, `<Esc>`) are kept.
-- - Command line is recorded as executed command (`:...`, `/...`) instead
--   of raw keys. Lines typed into `input()` prompts are not recorded.
-- - Keys typed inside 'mini.pick' pickers are not recorded.
--
-- Integration notes:
-- - Uses `typed` keys from `:h vim.on_key()`, so keys produced by mappings and
--   macro execution are not recorded.
-- - Keys re-fed by 'mini.clue' (after it shows a clue window) are detected and
--   not recorded twice.

local log_dir = vim.fn.stdpath('state') .. '/keylog'
vim.fn.mkdir(log_dir, 'p')

local Keylog = { enabled = true, lines = {} }
_G.Config.keylog = Keylog

Keylog.get_path = function() return log_dir .. '/' .. os.date('%Y-%m-%d') .. '.log' end

-- Current run of keys in a single mode
local cur = { mode = nil, ft = nil, time = nil, keys = {}, n_chars = 0 }

local push_cur = function()
  if cur.mode == nil then return end
  if cur.n_chars > 0 then table.insert(cur.keys, '«' .. cur.n_chars .. ' chars»') end
  if #cur.keys > 0 then
    local line = table.concat({ cur.time, cur.ft, cur.mode, table.concat(cur.keys) }, '\t')
    table.insert(Keylog.lines, line)
  end
  cur.mode, cur.keys, cur.n_chars = nil, {}, 0
end

Keylog.flush = function()
  push_cur()
  if #Keylog.lines == 0 then return end
  pcall(vim.fn.writefile, Keylog.lines, Keylog.get_path(), 'a')
  Keylog.lines = {}
end

local add = function(mode, key, is_char)
  local ft = vim.bo.filetype == '' and '-' or vim.bo.filetype
  if cur.mode ~= mode or cur.ft ~= ft then
    push_cur()
    cur.mode, cur.ft, cur.time = mode, ft, os.date('%H:%M:%S')
  end
  if is_char then
    cur.n_chars = cur.n_chars + 1
  else
    if cur.n_chars > 0 then
      table.insert(cur.keys, '«' .. cur.n_chars .. ' chars»')
      cur.n_chars = 0
    end
    table.insert(cur.keys, key)
  end
  if #Keylog.lines >= 200 then Keylog.flush() end
end

-- Keys fed with `nvim_feedkeys(keys, 't')` arrive in `vim.on_key()` as if they
-- were typed. This is how 'mini.clue' re-executes keys after it consumed them
-- while showing clues (so `gg` would be logged as `gggg`). Track such keys to
-- skip them. Applies to any plugin that "imitates typing" this way.
local refeed = ''
local orig_feedkeys = vim.api.nvim_feedkeys
vim.api.nvim_feedkeys = function(keys, mode, escape_ks, ...)
  if Keylog.enabled and type(mode) == 'string' and mode:find('t') then
    refeed = refeed .. vim.fn.keytrans(keys)
  end
  return orig_feedkeys(keys, mode, escape_ks, ...)
end

local ns = vim.api.nvim_create_namespace('config-keylog')
vim.on_key(function(_, typed)
  if not Keylog.enabled or typed == nil or typed == '' then return end

  -- Skip internal events (like `<Cmd>`, `<CursorHold>`, etc.) and mouse movement
  local key = vim.fn.keytrans(typed)
  if typed:find('^\128\253') or key == '<MouseMove>' or key == '<Ignore>' then return end

  -- Skip keys inside pickers (query text, navigation)
  if _G.MiniPick ~= nil and MiniPick.get_picker_state ~= nil and MiniPick.is_picker_active() then
    return
  end

  -- Skip keys fed by plugins (like 'mini.clue') as if typed
  if refeed ~= '' then
    if vim.startswith(refeed, key) then
      refeed = refeed:sub(#key + 1)
      return
    end
    refeed = ''
  end

  local mode = vim.api.nvim_get_mode().mode
  local m = mode:sub(1, 1)

  -- Command line is recorded on `CmdlineLeave`
  if m == 'c' or m == 'r' then return end

  -- Insert/Replace/Terminal: don't record text, only special keys
  if m == 'i' or m == 'R' or m == 't' then
    local is_char = vim.fn.strchars(typed) == 1 and typed:byte(1) >= 32 and typed:byte(1) ~= 127
    return add(m, key, is_char)
  end

  -- Normalize Visual/Select modes for readability
  local mode_name = ({ v = 'v', V = 'V', ['\22'] = '^V', s = 's', S = 'S', ['\19'] = '^S' })[m]
  add(mode_name or (mode:find('^no') and 'n' or m), key, false)
end, ns)

local gr = vim.api.nvim_create_augroup('config-keylog', {})

-- Record executed command line content instead of raw keys
vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = gr,
  callback = function()
    if not Keylog.enabled or vim.v.event.abort then return end
    local cmdtype = vim.fn.getcmdtype()
    if not (cmdtype == ':' or cmdtype == '/' or cmdtype == '?') then return end
    add('c', cmdtype .. vim.fn.getcmdline() .. '<CR>', false)
  end,
  desc = 'Keylog: record command line',
})

-- Remove key that started command line (`:`, `/`, `?`) as it is part of the
-- recorded command line
vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = gr,
  callback = function()
    if cur.keys[#cur.keys] == vim.fn.getcmdtype() then table.remove(cur.keys) end
  end,
  desc = 'Keylog: avoid duplicate command line key',
})

vim.api.nvim_create_autocmd({ 'VimLeavePre', 'FocusLost', 'CursorHold' }, {
  group = gr,
  callback = Keylog.flush,
  desc = 'Keylog: flush to disk',
})

vim.api.nvim_create_user_command('KeylogToggle', function()
  Keylog.flush()
  Keylog.enabled = not Keylog.enabled
  vim.notify('Keylog ' .. (Keylog.enabled and 'enabled' or 'disabled'))
end, { desc = 'Toggle keystroke logging' })
