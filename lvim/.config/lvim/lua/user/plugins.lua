-- Additional Plugins
lvim.plugins = {
	{
		"tpope/vim-surround",
	},
	{ "ojroques/vim-oscyank" },
	{
		"phaazon/hop.nvim",
		event = "BufRead",
		config = function()
			require("user.hop").config()
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	{
		"windwp/nvim-spectre",
		event = "BufRead",
		config = function()
			require("user.spectre").config()
		end,
	},
	-- end --
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("user.neoscroll").config()
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		event = "BufRead",
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("user.colorizer").config()
		end,
	},
	{
		"ruifm/gitlinker.nvim",
		requires = "nvim-lua/plenary.nvim",
		event = "BufRead",
		config = function()
			require("user.gitlinker").config()
		end,
	},
	{
		"tpope/vim-fugitive",
		cmd = {
			"G",
			"Git",
			"Gdiffsplit",
			"Gread",
			"Gwrite",
			"Ggrep",
			"GMove",
			"GDelete",
			"GBrowse",
			"GRemove",
			"GRename",
			"Glgrep",
			"Gedit",
		},
		ft = { "fugitive" },
	},
	{ "tpope/vim-rhubarb" },
	{
		"ray-x/lsp_signature.nvim",
		config = function()
			require("lsp_signature").on_attach()
		end,
		event = "BufRead",
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("user.autotag").config()
		end,
		-- event = "InsertEnter",
	},
	{
		"simrat39/symbols-outline.nvim",
		-- cmd = "SymbolsOutline",
		config = function()
			require("user.outline").config()
		end,
	},
	{
		"jose-elias-alvarez/nvim-lsp-ts-utils",
		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
	},
	{
		"sindrets/diffview.nvim",
		requires = "nvim-lua/plenary.nvim",
	},
	{
		"simrat39/rust-tools.nvim",
		config = function()
			require("lsp-servers.rust-tools").config()
		end,
		ft = { "rust", "rs" },
	},
	{
		"peterhoeg/vim-qml",
		event = "BufRead",
		ft = { "qml" },
	},
	{ "lambdalisue/suda.vim" },
	{
		"metakirby5/codi.vim",
		cmd = "Codi",
	},
	{
		"npxbr/glow.nvim",
		ft = { "markdown" },
	},
	{
		"folke/zen-mode.nvim",
		config = function()
			require("user.zen").config()
		end,
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		module = "persistence",
		config = function()
			require("persistence").setup({
				dir = vim.fn.expand(vim.fn.stdpath("config") .. "/session/"),
				options = { "buffers", "curdir", "tabpages", "winsize" },
			})
		end,
	},
	{ "tpope/vim-repeat" },
	{
		"felipec/vim-sanegx",
		event = "BufRead",
	},
	{
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({
				width = 120, -- Width of the floating window
				height = 25, -- Height of the floating window
				default_mappings = true, -- Bind default mappings
				debug = false, -- Print debug information
				opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
				post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
				-- You can use "default_mappings = true" setup option
				-- Or explicitly set keybindings
				-- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
				-- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
				-- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
			})
		end,
	},
	{
		"ptzz/lf.vim",
		config = function()
			require("user.lf")
		end,
	},
	{
		"voldikss/vim-floaterm",
		config = function()
			require("user.floaterm").config()
		end,
	},
}
