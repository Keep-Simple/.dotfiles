-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
lvim.leader = ","

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd("set nofen")
lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.terminal.active = true
lvim.builtin.terminal.shading_factor = 1
-- lvim.builtin.dap.active = true
lvim.builtin.gitsigns.opts.current_line_blame = true
lvim.builtin.cmp.completion.autocomplete = false
lvim.builtin.dashboard.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.view.auto_resize = true
lvim.builtin.nvimtree.setup.filters.custom = { "node_modules", ".git", ".idea", ".vscode" }

local tree_cb = require("nvim-tree.config").nvim_tree_callback
lvim.builtin.nvimtree.setup.view.mappings.list = {
	{ key = "<Tab>", cb = tree_cb("preview") },
	{ key = "K", cb = tree_cb("first_sibling") },
	{ key = "J", cb = tree_cb("last_sibling") },
	{ key = "I", cb = tree_cb("toggle_ignored") },
	{ key = "H", cb = tree_cb("toggle_dotfiles") },
	{ key = "<C-r>", cb = tree_cb("refresh") },
	{ key = "<C-t>" },
	{ key = "a", cb = tree_cb("create") },
	{ key = "gd", cb = tree_cb("remove") },
	{ key = "D", cb = tree_cb("trash") },
	{ key = "r", cb = tree_cb("rename") },
	{ key = "d", cb = tree_cb("cut") },
	{ key = "y", cb = tree_cb("copy") },
	{ key = "p", cb = tree_cb("paste") },
	{ key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
	{ key = "h", cb = tree_cb("close_node") },
	{ key = "v", cb = tree_cb("vsplit") },
	{ key = "C", cb = tree_cb("cd") },
	{ key = "gy", cb = tree_cb("copy_name") },
	{ key = "gpy", cb = tree_cb("copy_path") },
	{ key = "gay", cb = tree_cb("copy_absolute_path") },
	{ key = "-", cb = tree_cb("dir_up") },
	{ key = "s", cb = tree_cb("system_open") },
	{ key = "q", cb = tree_cb("close") },
	{ key = "g?", cb = tree_cb("toggle_help") },
}

lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"c",
	"javascript",
	"json",
	"lua",
	"python",
	"typescript",
	"css",
	"rust",
	"java",
	"yaml",
}

-- add your own keymapping
lvim.keys.normal_mode = {
	["<C-s>"] = ":w<cr>",
	["ga"] = "<cmd>lua require('lvim.core.telescope').code_actions()<cr>",
	["g["] = "<cmd>lua vim.diagnostic.goto_prev()<cr>",
	["g]"] = "<cmd>lua vim.diagnostic.goto_next()<cr>",
	-- zf = "<cmd>set fen<cr>",
	-- zF = "<cmd>set nofen<cr>",
}
lvim.builtin.cmp.mapping["<A-Space>"] = lvim.builtin.cmp.mapping["<C-Space>"]
lvim.builtin.which_key.mappings["W"] = {
	"<cmd>execute 'silent! write !sudo tee % >/dev/null' <bar> edit!<cr>",
	"Sudo Save",
}

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.pickers = { find_files = { hidden = true, no_ignore = true } }
lvim.builtin.telescope.defaults.file_ignore_patterns = { ".git", "node_modules" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.telescope.defaults.mappings = {
	-- for input mode
	i = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
		["<C-n>"] = actions.cycle_history_next,
		["<C-p>"] = actions.cycle_history_prev,
	},
	-- for normal mode
	n = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
	},
}

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["t"] = {
	name = "+Trouble",
	r = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
	f = { "<cmd>TroubleToggle lsp_definitions<cr>", "Definitions" },
	d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
	q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
	l = { "<cmd>TroubleToggle loclist<cr>", "Location list" },
	w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
}

lvim.builtin.which_key.mappings["gv"] = {
	name = "+Diffview",
	o = { "<cmd>DiffviewOpen<cr>", "Open" },
	c = { "<cmd>DiffviewClose<cr>", "Close" },
	r = { "<cmd>DiffviewRefresh<cr>", "Refresh" },
	f = { "<cmd>DiffviewRefresh<cr>", "Files History" },
}

lvim.builtin.which_key.mappings["gm"] = { "<cmd>Git<cr>", "Git menu" }

lvim.builtin.which_key.mappings["lt"] = {
	name = "+Typescript",
	i = { "<cmd>TSLspImportAll<cr>", "Import All" },
	o = { "<cmd>TSLspOrganize<cr>", "Organize Imports" },
	r = { "<cmd>TSLspRenameFile<cr>", "Rename File" },
	c = { "<cmd>TSLspImportCurrent<cr>", "Import under cursor" },
	h = { "<cmd>TSLspToggleInlayHints<cr>", "Toggle hints" },
}

local null_ls = require("null-ls")
-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	null_ls.builtins.formatting.prettier,
	{ command = "black" },
	{ command = "stylua" },
	{ command = "rustfmt" },
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	null_ls.builtins.diagnostics.eslint_d.with({
		condition = function(utils)
			return utils.root_has_file({
				".eslintrc.js",
				".eslintrc.cjs",
				".eslintrc.yaml",
				"eslintrc.yml",
				".eslintrc.json",
			})
		end,
	}),
	{ command = "flake8" },
})

vim.list_extend(lvim.lsp.override, { "rust_analyzer" })

-- Additional Plugins
lvim.plugins = {
	{
		"tpope/vim-surround",
	},
	{
		"phaazon/hop.nvim",
		event = "BufRead",
		config = function()
			require("hop").setup()
			vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
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
			require("nvim-ts-autotag").setup()
		end,
		event = "InsertEnter",
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
			require("rust-tools").setup({
				tools = {
					autoSetHints = true,
					hover_with_actions = true,
					runnables = {
						use_telescope = true,
					},
				},
				server = {
					cmd = { vim.fn.stdpath("data") .. "/lsp_servers/rust/rust-analyzer" },
					on_attach = require("lvim.lsp").common_on_attach,
					on_init = require("lvim.lsp").common_on_init,
				},
			})
		end,
		ft = { "rust", "rs" },
	},
	{
		"peterhoeg/vim-qml",
		event = "BufRead",
		ft = { "qml" },
	},
}

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
-- 	{ "Syntax", "*", "normal zR" },
-- }
