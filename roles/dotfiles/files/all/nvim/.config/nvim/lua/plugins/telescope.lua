local Util = require("lazyvim.util")

return {
	"nvim-telescope/telescope.nvim",
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
			opts = {
				defaults = {
					["<leader>F"] = { name = "+find" },
				},
			},
		},
	},
	keys = function()
		return {
			-- find
			{
				"<leader>f",
				function()
					if not pcall(require("telescope.builtin").git_files, { show_untracked = true }) then
						require("telescope.builtin").find_files()
					end
				end,
				desc = "Find Files",
			},
			{ "<leader>Fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>Fc", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
			{
				"<leader>Fh",
				function()
					require("telescope.builtin").find_files({ hidden = true, no_ignore = true, no_ignore_parent = true })
				end,
				desc = "Hidden (cwd)",
			},
			{
				"<leader>FH",
				function()
					local cwd = vim.fn.fnamemodify(vim.fn.finddir(".git", ".;"), ":h")
					require("telescope.builtin").find_files({
						hidden = true,
						no_ignore = true,
						no_ignore_parent = true,
						cwd = cwd,
					})
				end,
				desc = "Hidden (git dir)",
			},
			{ "<leader>FR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent" },
			-- git
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
			-- search
			{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
			{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
			{ "<leader>st", Util.telescope("live_grep", { cwd = false }), desc = "Text" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume" },
			{ "<leader>sw", Util.telescope("grep_string", { cwd = false }), desc = "Word" },
			{
				"<leader>uC",
				Util.telescope("colorscheme", { enable_preview = true }),
				desc = "Colorscheme with preview",
			},
			{
				"<leader>ss",
				Util.telescope("lsp_document_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				}),
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				Util.telescope("lsp_dynamic_workspace_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				}),
				desc = "Goto Symbol (Workspace)",
			},
		}
	end,
	opts = {
		defaults = {
			mappings = {
				i = {
					["<C-j>"] = function(...)
						return require("telescope.actions").move_selection_next(...)
					end,
					["<C-k>"] = function(...)
						return require("telescope.actions").move_selection_previous(...)
					end,
					["<C-n>"] = function(...)
						return require("telescope.actions").cycle_history_next(...)
					end,
					["<C-p>"] = function(...)
						return require("telescope.actions").cycle_history_prev(...)
					end,
				},
				n = {
					["q"] = function(...)
						return require("telescope.actions").close(...)
					end,
				},
			},
		},
	},
}
