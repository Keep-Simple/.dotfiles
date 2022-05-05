local status_ok, ts_utils = pcall(require, "nvim-lsp-ts-utils")
if not status_ok then
	vim.cmd([[ packadd nvim-lsp-ts-utils ]])
	ts_utils = require("nvim-lsp-ts-utils")
end

local opts = {
	init_options = require("nvim-lsp-ts-utils").init_options,
	on_attach = function(client)
		ts_utils.setup({
			debug = false,
			disable_commands = false,
			enable_import_on_completion = true,
			-- import all
			import_all_timeout = 5000, -- ms
			-- lower numbers = higher priority
			import_all_priorities = {
				same_file = 1, -- add to existing import statement
				local_files = 2, -- git files or files with relative path markers
				buffer_content = 3, -- loaded buffer content
				buffers = 4, -- loaded buffer names
			},
			import_all_scan_buffers = 100,
			import_all_select_source = false,
			-- if false will avoid organizing imports
			always_organize_imports = true,

			-- filter diagnostics
			filter_out_diagnostics_by_severity = {},
			filter_out_diagnostics_by_code = {},

			-- inlay hints
			auto_inlay_hints = true,
			inlay_hints_highlight = "Comment",
			inlay_hints_priority = 200, -- priority of the hint extmarks
			inlay_hints_throttle = 150, -- throttle the inlay hint request
			inlay_hints_format = { -- format options for individual hint kind
				Type = {},
				Parameter = {},
				Enum = {},
			},
			-- update imports on file move
			update_imports_on_move = false,
			require_confirmation_on_move = false,
			watch_dir = nil,
		})
		ts_utils.setup_client(client)
	end,
}

require("lvim.lsp.manager").setup("tsserver", opts)