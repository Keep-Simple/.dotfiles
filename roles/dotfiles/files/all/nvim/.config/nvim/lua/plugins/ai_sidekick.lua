return {
	{
		"folke/sidekick.nvim",
		dependencies = {
			{
				"folke/snacks.nvim",
				optional = true,
				opts = {
					picker = {
						actions = {
							sidekick_send = function(...)
								return require("sidekick.cli.picker.snacks").send(...)
							end,
						},
						win = {
							input = {
								keys = {
									["<a-a>"] = {
										"sidekick_send",
										mode = { "n", "i" },
									},
								},
							},
						},
					},
				},
			},
		},
		opts = {
			cli = {
				mux = {
					backend = "tmux",
					enabled = true,
					create = "window",
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
			{
				"<leader>at",
				function()
					-- require("sidekick.cli").send({ msg = "i\b" }) -- needed for gemini vim mode
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>av",
				function()
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>af",
				function()
					require("sidekick.cli").send({ msg = "{file}" })
				end,
				desc = "Send File",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			{
				"<leader>aa",
				function()
					-- Show CLI picker to select claude instance or create new one
					local State = require("sidekick.cli.state")
					require("sidekick.cli.ui.select").select({
						auto = false, -- Always show picker, never auto-select
						filter = { name = "claude" },
						cb = function(state)
							if state then
								State.attach(state, { show = true, focus = true })
							end
						end,
					})
				end,
				desc = "Sidekick Select/Attach Claude",
			},
		},
	},
	{
		"zbirenbaum/copilot.lua",
		opts = {
			copilot_node_command = vim.fn.trim(
				vim.fn.system("asdf where nodejs $(awk '/^nodejs/ {print $2}' ~/.tool-versions)")
			) .. "/bin/node",
		},
	},
}
