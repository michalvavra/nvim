-- Keep built-in <CR> (open entry) in quickfix, even if 'mini.jump2d' mapped
-- it before its own FileType revert was set up (it is loaded with `later()`).
vim.keymap.set('n', '<CR>', '<CR>', { buffer = true, noremap = true, desc = 'Open entry' })
