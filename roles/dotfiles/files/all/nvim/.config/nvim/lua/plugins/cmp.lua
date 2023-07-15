return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"rcarriga/cmp-dap",
		config = function()
			require("cmp").setup({
				enabled = function()
					return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
				end,
			})

			require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
				sources = {
					{ name = "dap" },
				},
			})
		end,
	},
	---@param opts cmp.ConfigSchema
	opts = function(_, opts)
		local cmp = require("cmp")

		opts.completion.autocomplete = false

		opts.mapping = vim.tbl_extend("force", opts.mapping, {
			["<C-l>"] = cmp.mapping.complete(),
			["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		})
		return opts
	end,
}
