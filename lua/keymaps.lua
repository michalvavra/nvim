local keymap = vim.keymap.set
local mini_pick = require('mini.pick')
local mini_files = require('mini.files')
local mini_bufremove = require('mini.bufremove')
local mini_extra = require('mini.extra')

-- Finding stuff
keymap("n", "<leader>f", function() mini_pick.builtin.files() end, { noremap = true, silent = true, desc = 'Find File' })
keymap("n", "<leader>e", function() mini_files.open(vim.api.nvim_buf_get_name(0)) end,
    { noremap = true, silent = true, desc = 'File Explorer' })
keymap("n", "<leader>oh", function() mini_pick.builtin.help() end, { noremap = true, silent = true, desc = 'Find Help' })
keymap("n", "<leader>ol", "<cmd>Lazy<cr>", { noremap = true, silent = true, desc = 'Lazy UI' })
keymap("n", "<leader>om", "<cmd>Mason<cr>", { noremap = true, silent = true, desc = 'Mason UI' })

-- Buffers related
keymap("n", "<leader>bd", function() mini_bufremove.delete() end,
    { noremap = true, silent = true, desc = 'Delete Buffer' })
keymap("n", "<leader>bn", "<cmd>bn<cr>", { noremap = true, silent = true, desc = 'Next Buffer' })
keymap("n", "<leader>bp", "<cmd>bp<cr>", { noremap = true, silent = true, desc = 'Previous Buffer' })
keymap("n", "<leader>bf", function() mini_pick.builtin.buffers() end,
    { noremap = true, silent = true, desc = 'Find Buffer' })

-- Code related (and LSP)
keymap("n", "<leader>cd", function() vim.lsp.buf.definition() end,
    { noremap = true, silent = true, desc = 'Go to Definition' })
keymap("n", "<leader>cs", function() mini_extra.pickers.lsp({ scope = 'document_symbol' }) end,
    { noremap = true, silent = true, desc = 'Show All Symbols' })
keymap("n", "<leader>cr", function() vim.lsp.buf.rename() end, { noremap = true, silent = true, desc = 'Rename This' })
keymap("n", "<leader>ca", function() vim.lsp.buf.code_action() end,
    { noremap = true, silent = true, desc = 'Code Actions' })
keymap("n", "<leader>cf", function() vim.lsp.buf.format() end, { noremap = true, silent = true, desc = 'Format Buffer' })
