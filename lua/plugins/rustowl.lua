return {
	'cordx56/rustowl',
	version = '*', -- Latest stable version
	build = 'cargo binstall rustowl',
	lazy = false, -- This plugin is already lazy
	opts = {
		client = {
			on_attach = function(_, buffer)
				vim.keymap.set('n', '<leader>o', function()
					require('rustowl').toggle(buffer)
				end, { buffer = buffer, desc = 'Toggle RustOwl' })
			end
		},
		auto_enable = true,
		colors = { -- Customize highlight colors (hex colors)
			lifetime = '#00cc00',   -- 🟩 green: variable's actual lifetime
			imm_borrow = '#0000cc', -- 🟦 blue: immutable borrowing
			mut_borrow = '#cc00cc', -- 🟪 purple: mutable borrowing
			move = '#cccc00',       -- 🟧 orange: value moved
			call = '#cccc00',       -- 🟧 orange: function call
			outlive = '#cc0000',    -- 🟥 red: lifetime error
		},
		highlight_style = 'underline', -- use 'underline' or "undercurl'
	},
}
