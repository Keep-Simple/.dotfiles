return {
	"Keep-Simple/lf.nvim",
	keys = {
		{ "<leader>e", "<cmd>Lf<cr>", desc = "Explorer" },
	},
	dependencies = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
	config = function()
		vim.g.lf_netrw = 1
		-- Defaults
		require("lf").setup({
			default_cmd = "lf", -- default `lf` command
			default_action = "edit", -- default action when `Lf` opens a file
			default_actions = { -- default action keybindings
				["<C-h>"] = "split",
				["<C-s>"] = "vsplit",
			},

			winblend = 0, -- psuedotransparency level
			dir = "", -- directory where `lf` starts ('gwd' is git-working-directory, "" is CWD)
			direction = "float", -- window type: float horizontal vertical
			border = "rounded", -- border kind: single double shadow curved
			-- height = 0.80, -- height of the *floating* window
			-- width = 0.85, -- width of the *floating* window
			escape_quit = false, -- map escape to the quit command (so it doesn't go into a meta normal mode)
			focus_on_open = true, -- focus the current file when opening Lf (experimental)
			tmux = false, -- tmux statusline can be disabled on opening of Lf
			mappings = true, -- whether terminal buffer mapping is enabled
			-- Layout configurations
			-- layout_mapping = "<A-u>", -- resize window with this key

			-- views = { -- window dimensions to rotate through
			-- 	{ width = 0.600, height = 0.600 },
			-- 	{
			-- 		width = 1.0 * fn.float2nr(fn.round(0.7 * o.columns)) / o.columns,
			-- 		height = 1.0 * fn.float2nr(fn.round(0.7 * o.lines)) / o.lines,
			-- 	},
			-- 	{ width = 0.800, height = 0.800 },
			-- 	{ width = 0.950, height = 0.950 },
			-- },
		})
	end,
}
