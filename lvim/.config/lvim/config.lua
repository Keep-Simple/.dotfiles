-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"

require("user.keys")
require("user.plugins")
require("user.bufferline")

-- folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd("set nofen")

lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.terminal.active = true
lvim.builtin.terminal.shading_factor = 1

-- when true brakes nvim-tree, when opening dir (so I modified lua/lvim/core/nvimtree.lua)
lvim.builtin.project.active = true

lvim.builtin.dap.active = true
lvim.builtin.notify.active = true
lvim.builtin.gitsigns.opts.current_line_blame = true
lvim.builtin.cmp.completion.autocomplete = false
lvim.builtin.dashboard.active = true

lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.open_on_setup = true
lvim.builtin.nvimtree.setup.view.auto_resize = true
lvim.builtin.nvimtree.setup.filters.custom = { "node_modules", ".git", ".idea", ".vscode" }

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

lvim.builtin.telescope.pickers = { find_files = { hidden = true, no_ignore = true } }
lvim.builtin.telescope.defaults.file_ignore_patterns = { ".git", "node_modules" }

local null_ls = require("null-ls")
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	null_ls.builtins.formatting.prettier,
	{ command = "black" },
	{ command = "stylua" },
	{ command = "rustfmt" },
	{ command = "gofmt" },
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
