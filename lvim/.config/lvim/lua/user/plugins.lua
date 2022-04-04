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
	{
		"gelfand/copilot.vim",
		requires = "hrsh7th/cmp-copilot",
		config = function()
			require("user.copilot").config()
		end,
	},
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("user.neoscroll").config()
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		config = function()
			require("user.bqf").config()
		end,
		event = { "BufRead", "BufNew" },
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
				width = 120,
				height = 25,
				default_mappings = true,
				debug = false,
				opacity = nil,
				post_open_hook = nil,
			})
		end,
	},
	{
		"ptzz/lf.vim",
		config = function()
			require("user.lf").config()
		end,
	},
	{
		"voldikss/vim-floaterm",
		config = function()
			require("user.floaterm").config()
		end,
	},
	{ "gurpreetatwal/vim-avro" },
	{
		"p00f/nvim-ts-rainbow",
	},
	{
		"jbyuki/instant.nvim",
		config = function()
			require("user.instant").config()
		end,
	},
	{
		"nathom/filetype.nvim",
		config = function()
			require("user.filetype").config()
		end,
	},
	{
		"ethanholz/nvim-lastplace",
		event = "BufRead",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = {
					"gitcommit",
					"gitrebase",
					"svn",
					"hgcommit",
				},
				lastplace_open_folds = true,
			})
		end,
	},
	{
		"nacro90/numb.nvim",
		event = "BufRead",
		config = function()
			require("numb").setup({
				show_numbers = true, -- Enable 'number' for the window while peeking
				show_cursorline = true, -- Enable 'cursorline' for the window while peeking
			})
		end,
	},
}
