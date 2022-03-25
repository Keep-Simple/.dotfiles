lvim.format_on_save = true
lvim.colorscheme = "onedarker"

require("user.keys")
require("user.bufferline")
require("user.plugins")
require("user.treesitter")
require("user.settings")
require("user.null-ls")
require("user.builtins")

require("lsp-servers.clangd")

vim.list_extend(lvim.lsp.override, {
	"clangd",
	"gopls",
	"rust_analyzer",
})
