lvim.plugins = {
	-- copy over ssh
	{ "ojroques/vim-oscyank" },
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("user.trouble").config()
		end,
	},
	-- find and replace
	{
		"windwp/nvim-spectre",
		event = "BufRead",
		config = function()
			require("user.spectre").config()
		end,
	},
	-- highlight hex color values
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
	-- harpoon
	{ "Keep-Simple/harpoon", requires = "nvim-lua/plenary.nvim" },
	{
		"RishabhRD/nvim-cheat.sh",
		requires = "RishabhRD/popfix",
		config = function()
			vim.g.cheat_default_window_layout = "vertical_split"
		end,
		opt = true,
		cmd = { "Cheat", "CheatWithoutComments", "CheatList", "CheatListWithoutComments" },
	},
	-- smart git wrapper
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
	{ "tpope/vim-repeat" },
	{
		"tpope/vim-surround",
	},
	-- autoclose and autorename html/xml tags
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
	-- smooth scrolling
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("user.neoscroll").config()
		end,
	},
	-- Git diffview
	{
		"sindrets/diffview.nvim",
		requires = "nvim-lua/plenary.nvim",
	},
	-- Sudo save
	{ "lambdalisue/suda.vim" },
	-- :Codi [name] opens buffers with [name] language interpreter
	{
		"metakirby5/codi.vim",
		cmd = "Codi",
	},
	-- Live markdown preview in browser
	{
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		ft = "markdown",
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		module = "persistence",
		config = function()
			require("persistence").setup()
		end,
	},
	-- gx opens links
	{
		"felipec/vim-sanegx",
		event = "BufRead",
	},
	-- lf wrapper
	{
		"ptzz/lf.vim",
		config = function()
			require("user.lf").config()
		end,
	},
	-- needed for lf wrapper
	{
		"voldikss/vim-floaterm",
		config = function()
			require("user.floaterm").config()
		end,
	},
	-- collaborative editing
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
	-- remember cursor position of the buffers
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
	-- pick on line numbers, when in command mode
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
	{ "rcarriga/cmp-dap" },
	{
		"mfussenegger/nvim-dap",
		as = "dap",
		config = function()
			require("user.dap")
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		as = "dapui",
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
	-- test runner with dap integration
	{
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-go",
			"haydenmeade/neotest-jest",
		},
		config = function()
			require("user.neotest").config()
		end,
	},
	-- show code context at the top of the buffer
	"nvim-treesitter/nvim-treesitter-context",
	-- tree sitter based textobjects
	"nvim-treesitter/nvim-treesitter-textobjects",
	-- mason is lsp/debugger/formatters/linters installer, this is config
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("user.mason").config()
		end,
	},

	-- language specific
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
	{
		"jose-elias-alvarez/typescript.nvim",
	},

	-- ai autocompletions
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
		disable = true,
	},
	-- vim training
	{ "ThePrimeagen/vim-be-good" },
}
