return {
	{
		"folke/sidekick.nvim",
		opts = {
			cli = {
				mux = {
					backend = "tmux",
					enabled = true,
					create = "split",
				},
			},
			copilot = {
				status = {
					enabled = false,
				},
			},
			nes = {
				enabled = false,
			},
			debug = false,
		},
		keys = {
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>at",
				function()
					require("sidekick.cli").send({ msg = "i\b" }) -- needed for gemini vim mode
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>av",
				function()
					require("sidekick.cli").send({ msg = "i\b" })
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").send({ msg = "i\b" })
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle({ name = "gemini" })
				end,
				desc = "Sidekick Toggle",
			},
		},
	},
	{
		"zbirenbaum/copilot.lua",
		opts = {
			copilot_node_command = (function()
				local version_output = vim.fn.system("node --version")
				if vim.v.shell_error == 0 then
					local major_version = tonumber(vim.fn.matchstr(version_output, "\\v(\\d+)."))
					if major_version and major_version >= 22 then
						return "node"
					end
					local path = vim.fn.trim(vim.fn.system("asdf where nodejs 22.9.0"))
					if vim.v.shell_error == 0 and path ~= "" then
						return path .. "/bin/node"
					end
					return "node" -- fallback to node if asdf fails
				end
			end)(),
		},
	},
}
