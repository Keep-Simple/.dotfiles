lvim.transparent_window = false
lvim.debug = true
lvim.log.level = "warn"

lvim.builtin.notify.active = false
lvim.builtin.terminal.active = true
lvim.builtin.project.active = true -- keep enabled for setting cwd correctly
lvim.builtin.dap.active = false
lvim.builtin.breadcrumbs.active = false
lvim.builtin.lir.active = false
lvim.builtin.indentlines.active = false
lvim.builtin.illuminate.active = false
lvim.builtin.nvimtree.active = false

lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.terminal.shading_factor = 1

lvim.builtin.alpha.mode = "dashboard"

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
