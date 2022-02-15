lvim.leader = ","

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
lvim.keys.normal_mode = {
	["<C-s>"] = ":w<cr>",
	["ga"] = "<cmd>lua require('lvim.core.telescope').code_actions()<cr>",
	["g["] = "<cmd>lua vim.diagnostic.goto_prev()<cr>",
	["g]"] = "<cmd>lua vim.diagnostic.goto_next()<cr>",
}
lvim.builtin.cmp.mapping["<A-Space>"] = lvim.builtin.cmp.mapping["<C-Space>"]
lvim.builtin.which_key.mappings["W"] = {
	"<cmd>SudaWrite<cr>",
	"Sudo Save",
}
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
	i = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
		["<C-n>"] = actions.cycle_history_next,
		["<C-p>"] = actions.cycle_history_prev,
	},
	n = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
	},
}
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

lvim.builtin.which_key.mappings["G"] = { "<cmd>Glow<cr>", "Markdown preview" }

lvim.builtin.which_key.mappings["lt"] = {
	name = "+Typescript",
	i = { "<cmd>TSLspImportAll<cr>", "Import All" },
	o = { "<cmd>TSLspOrganize<cr>", "Organize Imports" },
	r = { "<cmd>TSLspRenameFile<cr>", "Rename File" },
	c = { "<cmd>TSLspImportCurrent<cr>", "Import under cursor" },
	h = { "<cmd>TSLspToggleInlayHints<cr>", "Toggle hints" },
}

lvim.builtin.which_key.mappings["S"] = {
	name = "Session",
	c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
	l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
	Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}