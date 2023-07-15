return {
	"nvim-telescope/telescope.nvim",
	keys = {
		-- add a keymap to browse plugin files
		{
			"<leader>fp",
			function()
				require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
			end,
			desc = "Find Plugin File",
		},
	},
	-- change some options
	-- opts = {
	-- 	defaults = {
	-- 		layout_strategy = "horizontal",
	-- 		sorting_strategy = "ascending",
	-- 	},
	-- },
},
-- add telescope-fzf-native
{
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"nvim-telescope/telescope-live-grep-args.nvim",
		config = function()
			require("telescope").load_extension("live_grep_args")
		end,
	},
}

-- lvim.builtin.telescope.pickers.find_files = { hidden = true, no_ignore = true }
--
-- whk["s"]["t"] = { "<cmd>lua require'telescope'.extensions.live_grep_args.live_grep_args()<cr>", "Text" }
--
-- local _, trouble = pcall(require, "trouble.providers.telescope")
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
-- 	i = {
-- 		["<C-j>"] = actions.move_selection_next,
-- 		["<C-k>"] = actions.move_selection_previous,
-- 		["<C-n>"] = actions.cycle_history_next,
-- 		["<C-p>"] = actions.cycle_history_prev,
-- 		["<C-q>"] = trouble.open_with_trouble,
-- 	},
-- 	n = {
-- 		["<C-j>"] = actions.move_selection_next,
-- 		["<C-k>"] = actions.move_selection_previous,
-- 		["<C-q>"] = trouble.open_with_trouble,
-- 	},
-- }
-- local status, lga_actions = pcall(require, "telescope-live-grep-args.actions")
-- if not status then
-- 	return
-- end
-- local telescope = require("telescope")
--
-- lvim.builtin.telescope.on_config_done = function()
-- 	---@diagnostic disable-next-line: redundant-parameter
-- 	telescope.setup({
-- 		extensions = {
-- 			live_grep_args = {
-- 				auto_quoting = true, -- enable/disable auto-quoting
-- 				mappings = {
-- 					i = {
-- 						["<C-k>"] = lga_actions.quote_prompt(),
-- 						["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
-- 					},
-- 				},
-- 			},
-- 		},
-- 	})
-- end
