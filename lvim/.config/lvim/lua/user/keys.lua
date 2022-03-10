lvim.leader = ","

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

lvim.keys.normal_mode = {
	["<C-s>"] = "<cmd>w<cr>",
	["ga"] = "<cmd>lua require('lvim.core.telescope').code_actions()<cr>",
	["g["] = "<cmd>lua vim.diagnostic.goto_prev()<cr>",
	["g]"] = "<cmd>lua vim.diagnostic.goto_next()<cr>",
	-- wtf...
	["yy"] = "yy",
}

lvim.builtin.cmp.mapping["<A-Space>"] = lvim.builtin.cmp.mapping["<C-Space>"]
lvim.builtin.which_key.mappings["LC"] = { "<cmd>LvimCacheReset<cr>", "Cache Reset" }
lvim.builtin.which_key.mappings["W"] = {
	"<cmd>SudaWrite<cr>",
	"Sudo Save",
}

lvim.builtin.which_key.mappings["z"] = { "<cmd>ZenMode<cr>", "Zen" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<cr>", "Projects" }

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

lvim.builtin.which_key.mappings["gy"] = {
	"<cmd>lua require'gitlinker'.get_buf_range_url('n')<cr>",
	"Copy link",
}

lvim.builtin.which_key.mappings["gm"] = { "<cmd>Git<cr>", "Git menu" }

lvim.builtin.which_key.mappings["G"] = { "<cmd>Glow<cr>", "Markdown preview" }

lvim.builtin.which_key.mappings["lo"] = { "<cmd>SymbolsOutline<cr>", "Outline" }
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

lvim.builtin.which_key.mappings["r"] = {
	name = "Replace",
	r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
	w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
	f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
}

lvim.builtin.which_key.mappings["y"] = { ":OSCYank<cr>", "OSC52 Copy (for ssh)", mode = "v" }
lvim.builtin.which_key.mappings["e"] = { "<cmd>Lf<cr>", "Explorer" }
