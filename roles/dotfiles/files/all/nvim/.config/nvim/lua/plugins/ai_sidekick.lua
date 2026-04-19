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
					local State = require("sidekick.cli.state")
					local Select = require("sidekick.cli.ui.select")

					-- Patch picker format once: append tmux window index for disambiguation.
					if not Select._window_idx_patched then
						Select._window_idx_patched = true
						local Util = require("sidekick.util")
						local orig = Select.format
						local pane_window = {} ---@type table<string,string>
						local function refresh_panes()
							pane_window = {}
							local lines = Util.exec(
								{ "tmux", "list-panes", "-a", "-F", "#{pane_id} #{window_index}" },
								{ notify = false }
							) or {}
							for _, line in ipairs(lines) do
								local id, idx = line:match("^(%%%d+)%s+(%d+)$")
								if id then
									pane_window[id] = idx
								end
							end
						end
						Select.format = function(state, picker)
							local ret = orig(state, picker)
							local pane_id = state.session and state.session.tmux_pane_id
							local idx = pane_id and pane_window[pane_id]
							if idx then
								ret[#ret + 1] = { (" w%s"):format(idx), "Special" }
							end
							return ret
						end
						-- Wrap select() so cache refreshes before each open.
						local orig_select = Select.select
						Select.select = function(opts)
							refresh_panes()
							return orig_select(opts)
						end
					end

					-- Detach attached claude sessions so picker re-prompts.
					for _, s in ipairs(State.get({ name = "claude", attached = true })) do
						State.detach(s)
					end

					Select.select({
						auto = false,
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
