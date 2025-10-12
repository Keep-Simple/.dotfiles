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
}
