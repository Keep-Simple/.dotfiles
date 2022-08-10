require("user.treesitter")

lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.terminal.active = true
lvim.builtin.terminal.shading_factor = 1

lvim.builtin.project.active = true
lvim.builtin.dap.active = true
lvim.builtin.notify.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.nvimtree.active = false

lvim.builtin.cmp.completion.autocomplete = false
lvim.builtin.gitsigns.opts.current_line_blame = true

lvim.builtin.project.detection_methods = { "lsp", "pattern" }

lvim.builtin.telescope.pickers = { find_files = { hidden = true, no_ignore = true } }
lvim.builtin.telescope.defaults.file_ignore_patterns = {
	"__pycache__/*",
	"__pycache__/",
	"node_modules/*",
	"node_modules/",
	".git/",
	".github/",
	".gradle/",
	".idea/",
	".vscode/",
}
lvim.builtin.telescope.defaults.path_display = { "smart" }

lvim.lsp.diagnostics.float.focusable = true
lvim.lsp.float.focusable = true
