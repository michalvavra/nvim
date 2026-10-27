-- ┌────────────────────────┐
-- │ vim.pack user commands │
-- └────────────────────────┘
--
-- Short commands around the built-in plugin manager (see `:h vim.pack`).
-- All accept optional plugin names (with completion); no names = all plugins.
-- - `:PackUpdate [names]`  - fetch updates, review, `:write` to apply / `:quit` to cancel.
-- - `:PackUpdate! [names]` - fetch and apply updates without confirmation.
-- - `:PackStatus [names]`  - show installed plugins and revisions (offline, no fetch).
-- - `:PackSync [names]`    - restore plugins to revisions in 'nvim-pack-lock.json'.
-- - `:PackClean[!]`        - delete plugins on disk not added in config (`!` skips prompt).
-- - `:PackDel {names}`     - delete specific plugins from disk.
-- - `:PackLog`             - open the update log.

local pack_names = function()
  return vim.tbl_map(function(p) return p.spec.name end, vim.pack.get(nil, { info = false }))
end

local complete_pack_names = function(arg_lead)
  return vim.tbl_filter(function(n) return vim.startswith(n, arg_lead) end, pack_names())
end

local names_or_nil = function(fargs) return #fargs > 0 and fargs or nil end

local cmd = function(name, f, opts)
  opts = vim.tbl_extend('force', { nargs = '*' }, opts or {})
  if opts.nargs ~= 0 then opts.complete = complete_pack_names end
  vim.api.nvim_create_user_command(name, f, opts)
end

cmd('PackUpdate', function(o)
  vim.pack.update(names_or_nil(o.fargs), { force = o.bang })
end, { bang = true, desc = 'Update plugins (! to skip confirmation)' })

cmd('PackStatus', function(o)
  vim.pack.update(names_or_nil(o.fargs), { offline = true })
end, { desc = 'Show installed plugins without fetching' })

cmd('PackSync', function(o)
  vim.pack.update(names_or_nil(o.fargs), { target = 'lockfile' })
end, { desc = 'Sync plugins to lockfile revisions' })

cmd('PackClean', function(o)
  local inactive = vim
    .iter(vim.pack.get(nil, { info = false }))
    :filter(function(p) return not p.active end)
    :map(function(p) return p.spec.name end)
    :totable()
  if #inactive == 0 then return vim.notify('PackClean: nothing to clean') end
  local msg = 'Delete unused plugins?\n  ' .. table.concat(inactive, '\n  ')
  if o.bang or vim.fn.confirm(msg, '&Yes\n&No', 2) == 1 then vim.pack.del(inactive) end
end, { nargs = 0, bang = true, desc = 'Delete plugins not used in config' })

cmd('PackDel', function(o) vim.pack.del(o.fargs) end, { nargs = '+', desc = 'Delete plugins from disk' })

cmd('PackLog', function()
  vim.cmd.tabedit(vim.fs.joinpath(vim.fn.stdpath('log'), 'nvim-pack.log'))
end, { nargs = 0, desc = 'Open vim.pack log' })
