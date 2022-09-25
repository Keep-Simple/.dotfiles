lvim.leader = ","

lvim.builtin.terminal.open_mapping = "<C-t>"
-- bruh..., ignore default lvim debugger mappings
lvim.builtin.dap.on_config_done = function()
	lvim.builtin.which_key.mappings["d"] = {
		name = "Debug",
		t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
		B = { "<cmd>lua require'dap'.clear_breakpoints()<cr>", "Clear all breakpoints" },
		b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
		c = { "<cmd>lua require'dap'.continue()<cr>", "Start/Continue" },
		C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
		d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
		g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
		i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
		o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
		u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
		p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
		r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
		R = { "<cmd>lua require('dap').repl.close()<cr>", "Close Repl" },
		q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
	}
end
-- ignore project.nvim mapping, use only packer
lvim.builtin.which_key.mappings["P"] = lvim.builtin.which_key.mappings["p"]
lvim.builtin.which_key.mappings["p"] = nil

local _, trouble = pcall(require, "trouble.providers.telescope")
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
	i = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
		["<C-n>"] = actions.cycle_history_next,
		["<C-p>"] = actions.cycle_history_prev,
		["<C-q>"] = trouble.open_with_trouble,
	},
	n = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
		["<C-q>"] = trouble.open_with_trouble,
	},
}

lvim.lsp.buffer_mappings.normal_mode["gr"] = nil
lvim.keys.normal_mode = {
	["<C-s>"] = "<cmd>w<cr>",
	["ga"] = "<cmd>lua require('lvim.core.telescope').code_actions()<cr>",
	["g["] = "<cmd>lua vim.diagnostic.goto_prev()<cr>",
	["g]"] = "<cmd>lua vim.diagnostic.goto_next()<cr>",
	["gr"] = "<cmd>TroubleToggle lsp_references<cr>",
	["gq"] = "<cmd>TroubleToggle quickfix<cr>",
	["gS"] = "<cmd>setlocal spell!<cr>",
	["<C-Up>"] = ":resize +2<CR>",
	["<C-Down>"] = ":resize -2<CR>",
	["<C-Left>"] = ":vertical resize +2<CR>",
	["<C-Right>"] = ":vertical resize -2<CR>",
	["<S-l>"] = ":BufferLineCycleNext<CR>",
	["<S-h>"] = ":BufferLineCyclePrev<CR>",
	["<S-x>"] = ":BufferKill<CR>",
	-- ["gd"] = "<cmd>Trouble lsp_definitions<cr>",
	-- wtf...
	-- ["yy"] = "yy",
}

vim.cmd([[
    " backward search
     nnoremap \ ,
    "leader instead of , is not working for some reason
    "paste and ignore deleted content
     xnoremap ,p "_dp
    "delete completly (to the null register)
     " nnoremap ,d "_d
     " vnoremap ,d "_d
    "copy to the clipboard
     nnoremap ,y "+y
     vnoremap ,y "+y
]])

lvim.builtin.which_key.mappings["LC"] = { "<cmd>LvimCacheReset<cr>", "Lvim cache reset" }
lvim.builtin.which_key.mappings["W"] = {
	"<cmd>SudaWrite<cr>",
	"sudo save",
}
lvim.builtin.which_key.mappings["n"] = {
	"<cmd>noautocmd w<cr>",
	"Save & no fmt",
}

lvim.builtin.which_key.mappings["z"] = { "<cmd>ZenMode<cr>", "Zen" }

lvim.builtin.which_key.mappings["T"] = {
	name = "Trouble",
	r = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
	f = { "<cmd>TroubleToggle lsp_definitions<cr>", "Definitions" },
	d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
	q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
	l = { "<cmd>TroubleToggle loclist<cr>", "Location list" },
	w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
}

lvim.builtin.which_key.mappings["gv"] = {
	name = "Diffview",
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
	name = "Typescript",
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

lvim.builtin.which_key.mappings["Y"] = { ":OSCYank<cr>", "OSC52 Copy (for ssh)", mode = "v" }
lvim.builtin.which_key.mappings["e"] = { "<cmd>Lf<cr>", "Explorer" }
lvim.builtin.which_key.mappings["ss"] = { "<cmd>Telescope resume<cr>", "Resume search" }

lvim.builtin.which_key.mappings["t"] = {
	name = "Test Runner",
	f = { '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', "Run file" },
	n = { "<cmd>lua require('neotest').run.run()<cr>", "Run nearest" },
	r = { "<cmd>lua require('neotest').run.run_last()<cr>", "Re-run latest" },
	q = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop nearest" },
	d = {
		name = "Debug",
		n = { "<cmd>lua require('neotest').run.run({ strategy='dap' })<cr>", "Debug nearest" },
		f = { "<cmd>lua require('neotest').run.run({ vim.fn.expand('%'), strategy='dap' })<cr>", "Debug file" },
		r = { "<cmd>lua require('neotest').run.run_last({ strategy='dap' })<cr>", "Re-run latest with debug" },
	},
	s = { "<cmd>lua require('neotest').summary.open()<cr>", "Toogle Summary" },
	o = { "<cmd>lua require('neotest').output.open({ enter = true, short = false })<cr>", "Show output" },
}
