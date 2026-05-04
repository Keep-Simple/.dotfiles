local function get_git_dir()
	return vim.fn.fnamemodify(vim.fn.finddir(".git", ".;"), ":h")
end

local function toggle_root(picker)
	picker.opts.dirs = (picker.opts.dirs and #picker.opts.dirs > 0) and {} or { get_git_dir() }
	picker:find()
end

local picker_toggles = {
	actions = { toggle_root = toggle_root },
	win = {
		input = {
			keys = {
				["H"] = { "toggle_hidden", mode = "n", desc = "Toggle hidden" },
				["I"] = { "toggle_ignored", mode = "n", desc = "Toggle ignored" },
				["R"] = { "toggle_root", mode = "n", desc = "Toggle git root" },
			},
		},
	},
}

return {
	"nvim-telescope/telescope.nvim",
	version = false,
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
	},
	keys = function()
		return {
			-- find
			{
				"<leader>f",
				function()
					Snacks.picker.smart(vim.tbl_deep_extend("force", {
						multi = { "buffers", "recent", "files" },
						matcher = { cwd_bonus = true, frecency = true, sort_empty = true },
					}, picker_toggles))
				end,
				desc = "Find (smart)",
			},
			{
				"<leader>r",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume picker",
			},
			{
				"<leader>b",
				function()
					Snacks.picker.buffers({
						win = {
							input = {
								keys = {
									["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
								},
							},
							list = { keys = { ["dd"] = "bufdelete" } },
						},
					})
				end,
				desc = "Buffers",
			},
			-- git
			{
				"<leader>gb",
				function()
					Snacks.picker.git_branches()
				end,
				desc = "Git Branches",
			},
			{
				"<leader>gl",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git Log",
			},
			{
				"<leader>gL",
				function()
					Snacks.picker.git_log_line()
				end,
				desc = "Git Log Line",
			},
			{
				"<leader>gs",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git Status",
			},
			{
				"<leader>gS",
				function()
					Snacks.picker.git_stash()
				end,
				desc = "Git Stash",
			},
			{
				"<leader>gd",
				function()
					Snacks.picker.git_diff()
				end,
				desc = "Git Diff (Hunks)",
			},
			{
				"<leader>gf",
				function()
					Snacks.picker.git_log_file()
				end,
				desc = "Git Log File",
			},

			{
				"<leader>sa",
				function()
					Snacks.picker.autocmds()
				end,
				desc = "Autocmds",
			},
			{
				"<leader>sb",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>sc",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>sC",
				function()
					Snacks.picker.commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>sd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>sD",
				function()
					Snacks.picker.diagnostics_buffer()
				end,
				desc = "Buffer Diagnostics",
			},
			{
				"<leader>sh",
				function()
					Snacks.picker.help()
				end,
				desc = "Help Pages",
			},
			{
				"<leader>st",
				function()
					Snacks.picker.grep(vim.tbl_deep_extend("force", { hidden = true }, picker_toggles))
				end,
				desc = "Grep",
			},
			{
				"<leader>sw",
				function()
					Snacks.picker.grep_word(vim.tbl_deep_extend("force", { hidden = true }, picker_toggles))
				end,
				mode = { "n", "x" },
				desc = "Grep word",
			},
			{
				"<leader>sk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>sm",
				function()
					Snacks.picker.marks()
				end,
				desc = "Marks",
			},
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
		}
	end,
	opts = {
		defaults = {
			mappings = {
				i = {
					["<C-j>"] = require("telescope.actions").move_selection_next,
					["<C-k>"] = require("telescope.actions").move_selection_previous,
					["<C-n>"] = require("telescope.actions").cycle_history_next,
					["<C-p>"] = require("telescope.actions").cycle_history_prev,
				},
				n = {
					["q"] = require("telescope.actions").close,
				},
			},
		},
	},
}
