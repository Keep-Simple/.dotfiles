return {
	"nvim-lualine/lualine.nvim",
	config = function()
		-- PERF: we don't need this lualine require madness 🤷
		local lualine_require = require("lualine_require")
		lualine_require.require = require
		local icons = require("lazyvim.config").icons

		require("lualine").setup({
			options = {
				theme = "auto",
				globalstatus = false,
				disabled_filetypes = { statusline = { "dashboard", "alpha" } },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {
					LazyVim.lualine.root_dir(),
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					{ LazyVim.lualine.pretty_path() },
				},
				lualine_x = {
					Snacks.profiler.status(),
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Snacks.util.color("Debug") } end,
          },
					{
						function()
							local status = require("sidekick.status").cli()
							return " " .. (#status > 1 and #status or "")
						end,
						cond = function()
							return #require("sidekick.status").cli() > 0
						end,
						color = function()
							return { fg = Snacks.util.color("Special") }
						end,
					},
					{
						"diff",
						symbols = {
							added = icons.git.added,
							modified = icons.git.modified,
							removed = icons.git.removed,
						},
					},
				},
				lualine_y = {
					function()
						local bufnr = vim.api.nvim_get_current_buf()
						local clients = vim.lsp.get_clients({ bufnr = bufnr })
						if next(clients) == nil then
							return ""
						end

						local c = {}
						for _, client in pairs(clients) do
							if client.name ~= "null-ls" then
								table.insert(c, client.name)
							end
						end
						return "\u{f085} " .. table.concat(c, "|")
					end,
				},
				lualine_z = { "searchcount", "location" },
			},
			extensions = {
				"lazy",
				"nvim-dap-ui",
				"fugitive",
				"mason",
				"quickfix",
				"symbols-outline",
				"toggleterm",
				"trouble",
				"man",
			},
		})
	end,
}
