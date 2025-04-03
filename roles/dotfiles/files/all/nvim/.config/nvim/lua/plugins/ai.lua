return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"j-hui/fidget.nvim",
			{
				"ravitemer/mcphub.nvim",
				cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
				build = "bundled_build.lua", -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
				config = function()
					require("mcphub").setup({
						port = 3000, -- Port for MCP Hub server
						config = vim.fn.expand("~/.config/nvim/mcpservers.json"), -- Absolute path to config file
						use_bundled_binary = true,
						log = {
							level = vim.log.levels.WARN,
							to_file = false,
							file_path = nil,
							prefix = "MCPHub",
						},
					})
				end,
			},
		},
		keys = {
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>ah",
				"<cmd>MCPHub<cr>",
				desc = "MCP Hub",
			},
			{
				"<leader>aa",
				"<cmd>CodeCompanionChat Toggle<cr>",
				desc = "Chat",
				mode = { "n", "v" },
			},
			{
				"<leader>ap",
				"<cmd>CodeCompanionActions<cr>",
				desc = "Actions Palette",
				mode = { "n", "v" },
			},
			{
				"<leader>aA",
				"<cmd>CodeCompanionAdd<cr>",
				desc = "Add selected text",
				mode = { "v" },
			},
			{
				"<leader>ai",
				"<cmd>CodeCompanion<cr>",
				desc = "Inline assistant",
				mode = { "n", "v" },
			},

			{
				"<leader>ac",
				":CodeCompanionCmd<space>",
				desc = "Generate nvim command",
				mode = { "n", "v" },
			},
		},
		init = function()
			require("fidget-spinner-ai"):init()
		end,
		opts = {
			display = {
				chat = {
					intro_message = "Press ? for options",
					show_settings = false,
					auto_scroll = false,
					show_header_separator = false,
				},
			},
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "claude-3.7-sonnet",
							},
						},
					})
				end,
				opts = {
					show_defaults = false,
				},
				-- Define your custom adapters here
			},
			strategies = {
				inline = {
					adapter = "copilot",
				},
				cmd = {
					adapter = "copilot",
				},
				chat = {
					adapter = "copilot",
					tools = {
						["mcp"] = {
							-- calling it in a function would prevent mcphub from being loaded before it's needed
							callback = function()
								return require("mcphub.extensions.codecompanion")
							end,
							description = "Call tools and resources from the MCP Servers",
							opts = {
								requires_approval = true,
							},
						},
					},
				},
			},
		},
	},
}
