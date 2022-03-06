lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"

require("user.keys")
require("user.plugins")
require("lsp-servers.clangd")
require("user.null-ls")

lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.terminal.active = true
lvim.builtin.terminal.shading_factor = 1

lvim.builtin.project.active = true
lvim.builtin.dap.active = true
lvim.builtin.notify.active = true
lvim.builtin.dashboard.active = true
lvim.builtin.treesitter.ensure_installed = "maintained"
lvim.builtin.nvimtree.active = false

lvim.lsp.automatic_servers_installation = true

-- folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd("set nofen")
vim.cmd([[
  let g:lf_map_keys = 0
  let g:lf_replace_netrw = 1
  ]])

lvim.builtin.cmp.completion.autocomplete = false
lvim.builtin.gitsigns.opts.current_line_blame = true

lvim.builtin.telescope.pickers = { find_files = { hidden = true, no_ignore = true } }
lvim.builtin.telescope.defaults.file_ignore_patterns = { ".git", "node_modules" }

vim.list_extend(lvim.lsp.override, { "rust_analyzer", "clangd" })
