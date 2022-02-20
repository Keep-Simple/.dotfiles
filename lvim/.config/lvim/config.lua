lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"

require("user.keys")
require("user.plugins")

lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.terminal.active = true
lvim.builtin.terminal.shading_factor = 1

lvim.builtin.project.active = true
lvim.builtin.dap.active = true
lvim.builtin.notify.active = true
lvim.builtin.dashboard.active = true
lvim.builtin.nvimtree.active = false

-- folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd("set nofen")
vim.cmd([[
  let g:lf_map_keys = 0
  let g:lf_replace_netrw = 1
  ]])

lvim.builtin.gitsigns.opts.current_line_blame = true
lvim.builtin.cmp.completion.autocomplete = false
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
	{ command = "shfmt" },
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
