return {
	{
        -- https://github.com/echasnovski/mini.nvim
        'echasnovski/mini.nvim',
		version = false,
		config = function()
            -- Common configuration presets
			require('mini.basics').setup()

            -- Extend and create a/i textobjects
			require('mini.ai').setup()

            -- Statusline
			require('mini.statusline').setup()

			-- Comment lines
			require('mini.comment').setup()

			-- Navigate and manipulate file system
			require('mini.files').setup()

			-- Pick anything
			require('mini.pick').setup()

			-- Pick anything
			require('mini.bufremove').setup()

			-- Extra 'mini.nvim' functionality (pickers, ...)
			require('mini.extra').setup()

            -- Completion and signature help
			require('mini.completion').setup({
				window = {
					info = { border = 'rounded' },
					signature = { border = 'rounded' },
				}
			})

			-- Show next key clues
			require('mini.clue').setup({
				triggers = {
					-- Leader triggers
					{ mode = 'n', keys = '<Leader>' },
					{ mode = 'x', keys = '<Leader>' },

					-- Built-in completion
					{ mode = 'i', keys = '<C-x>' },

					-- `g` key
					{ mode = 'n', keys = 'g' },
					{ mode = 'x', keys = 'g' },

					-- Marks
					{ mode = 'n', keys = "'" },
					{ mode = 'n', keys = '`' },
					{ mode = 'x', keys = "'" },
					{ mode = 'x', keys = '`' },

					-- Registers
					{ mode = 'n', keys = '"' },
					{ mode = 'x', keys = '"' },
					{ mode = 'i', keys = '<C-r>' },
					{ mode = 'c', keys = '<C-r>' },

					-- Window commands
					{ mode = 'n', keys = '<C-w>' },

					-- `z` key
					{ mode = 'n', keys = 'z' },
					{ mode = 'x', keys = 'z' },
				},
				clues = {
					{ mode = 'n', keys = '<Leader>c', desc = 'Code' },
					{ mode = 'n', keys = '<Leader>b', desc = 'Buffer' },
					{ mode = 'n', keys = '<Leader>o', desc = 'Other' },
					{ mode = 'g', keys = '<Leader>g', desc = 'Goto' },
					-- Enhance this by adding descriptions for <Leader> mapping groups
					function() MiniClue.gen_clues.g() end,
					function() MiniClue.gen_clues.builtin_completion() end,
					function() MiniClue.gen_clues.marks() end,
					function() MiniClue.gen_clues.registers() end,
					function() MiniClue.gen_clues.windows() end,
					function() MiniClue.gen_clues.z() end,
				},
			})
		end,
	}
}
