local function get_git_dir()
	return vim.fn.fnamemodify(vim.fn.finddir(".git", ".;"), ":h")
end

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
		{
			"folke/which-key.nvim",
			opts = function(_, opts)
				require("which-key").add({ "<leader>F", group = "find/files" })
				return opts
			end,
		},
	},
	keys = function()
		return {
			-- find
			{
				"<leader>f",
				function()
					Snacks.picker.git_files({ untracked = true })
				end,
				desc = "Find git files",
			},
			{
				"<leader>Ff",
				function()
					Snacks.picker.files()
				end,
				desc = "files",
			},
			{
				"<leader>Fa",
				function()
					Snacks.picker.files({ hidden = true, ignored = true })
				end,
				desc = "files (ignore, hidden)",
			},
			{
				"<leader>FA",
				function()
					Snacks.picker.files({ hidden = true, ignored = true, dirs = { get_git_dir() } })
				end,
				desc = "dir=(git root) files (ignore, hidden)",
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
					Snacks.picker.grep({
						hidden = true,
					})
				end,
				desc = "Text",
			},
			{
				"<leader>sT",
				function()
					Snacks.picker.grep({
						hidden = true,
						dirs = { get_git_dir() },
					})
				end,
				desc = "dir=(git root) Text",
			},
			{
				"<leader>sA",
				function()
					Snacks.picker.grep({
						hidden = true,
						ignored = true,
						dirs = { get_git_dir() },
					})
				end,
				desc = "dir=(git root) Text (with ignore)",
			},
			{
				"<leader>sW",
				function()
					Snacks.picker.grep_word({
						hidden = true,
						dirs = { get_git_dir() },
					})
				end,
				mode = { "n", "x" },
				desc = "dir=(git root) Word",
			},
			{
				"<leader>sw",
				function()
					Snacks.picker.grep_word({
						hidden = true,
					})
				end,
				mode = { "n", "x" },
				desc = "Word",
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
			{
				"<leader>sR",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume",
			},
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
