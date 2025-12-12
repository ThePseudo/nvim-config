-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = {},
	-- automatically check for plugin updates
	checker = { enabled = true },
})

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme='gruvbox',
		globalstatus = true,
	}
})

require("catppuccin").setup({
	flavour="mocha",
	auto_integrations=true,
})

vim.cmd.colorscheme "catppuccin"

require("aerial").setup({
	-- optionally use on_attach to set keymaps when aerial has attached to a buffer
	on_attach = function(bufnr)
		-- Jump forwards/backwards with '{' and '}'
		vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
		vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
		-- You probably also want to set a keymap to toggle aerial
		vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
	end,
	layout = {
		-- These control the width of the aerial window.
		-- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		-- min_width and max_width can be a list of mixed types.
		-- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
		max_width = { 40, 0.2 },
		width = 40,
		min_width = 10,

		-- key-value pairs of window-local options for aerial window (e.g. winhl)
		win_opts = {},

		-- Determines the default direction to open the aerial window. The 'prefer'
		-- options will open the window in the other direction *if* there is a
		-- different buffer in the way of the preferred direction
		-- Enum: prefer_right, prefer_left, right, left, float
		default_direction = "prefer_right",

		-- Determines where the aerial window will be opened
		--   edge   - open aerial at the far right/left of the editor
		--   window - open aerial to the right/left of the current window
		placement = "edge",

		-- When the symbols change, resize the aerial window (within min/max constraints) to fit
		resize_to_content = true,

		-- Preserve window size equality with (:help CTRL-W_=)
		preserve_equality = false,
  	},
})

require("barbar").setup({
	icons = {
		buffer_index = true,
		buffer_number = false,
	}
})

require("conform").setup({
	formatters_by_ft = {
		lua = {"stylua"},
		python = {"isort", "black"},
		rust = {"rustfmt", lsp_format = "fallback" },
	}

})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

