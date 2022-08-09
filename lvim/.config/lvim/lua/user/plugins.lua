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
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("user.trouble").config()
		end,
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
		disable = true,
	},
	{
		"tzachar/cmp-tabnine",
		run = "./install.sh",
		requires = "hrsh7th/nvim-cmp",
		event = "InsertEnter",
	},
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("user.neoscroll").config()
		end,
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
	},
	{
		"simrat39/symbols-outline.nvim",
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
			require("user.rust-tools").config()
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
				show_numbers = true,
				show_cursorline = true,
			})
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
		config = function()
			require("user.dapui").config()
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("user.dap-virtual-text").config()
		end,
	},
	{
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-go",
		},
		config = function()
			require("user.neotest").config()
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		requires = "kevinhwang91/promise-async",
		config = function()
			require("user.nvim-ufo").config()
		end,
		disable = true,
	},
	{ "nvim-treesitter/nvim-treesitter-context" },
}
