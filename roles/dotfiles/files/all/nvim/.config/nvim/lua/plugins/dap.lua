return {
	"mfussenegger/nvim-dap",
	keys = function()
		return {
			{
				"<leader>dT",
				"<cmd>PBSetConditionalBreakpoint<cr>",
				desc = "Breakpoint Condition",
			},
			{
				"<leader>dt",
				"<cmd>PBToggleBreakpoint<cr>",
				desc = "Toggle Breakpoint",
			},
			{ "<leader>dB", "<cmd>PBClearAllBreakpoints<cr>", desc = "Clear all breakpoints" },
			{
				"<leader>dm",
				function()
					local pb_utils = require("persistent-breakpoints.utils")
					local pb_api = require("persistent-breakpoints.api")
					local inmemory = require("persistent-breakpoints.inmemory")

					local normal_path = pb_utils.get_bps_path()
					local muted_path = normal_path:gsub("%.json$", ".muted.json")

					-- Check if currently muted by looking for .muted.json file
					local muted_file = io.open(muted_path, "r")

					if muted_file then
						-- UNMUTE: restore from .muted.json
						muted_file:close()
						local muted_bps = pb_utils.load_bps(muted_path)
						inmemory.bps = muted_bps
						pb_utils.write_bps(normal_path, muted_bps)
						os.remove(muted_path)
						pb_api.reload_breakpoints()

						-- Refresh dap-ui to show restored breakpoints
						local ok, dapui = pcall(require, "dapui")
						if ok then
							dapui.update_render({})
						end

						vim.notify("🔊 Breakpoints unmuted", vim.log.levels.INFO)
					else
						-- MUTE: save to .muted.json, clear normal
						local current_bps = vim.deepcopy(inmemory.bps)
						if vim.tbl_isempty(current_bps) then
							vim.notify("No breakpoints to mute", vim.log.levels.WARN)
							return
						end
						pb_utils.write_bps(muted_path, current_bps)
						pb_api.clear_all_breakpoints()

						local ok, dapui = pcall(require, "dapui")
						if ok then
							dapui.update_render({})
						end

						vim.notify("🔇 Breakpoints muted", vim.log.levels.WARN)
					end
				end,
				desc = "Toggle Mute/Unmute All Breakpoints",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to line (no execute)",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Down",
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Up",
			},
			{
				"<leader>dr",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dp",
				function()
					require("dap").pause()
				end,
				desc = "Pause",
			},
			{
				"<leader>dR",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle REPL",
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
				desc = "Session",
			},
			{
				"<leader>dq",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
			},
		}
	end,
	dependencies = {
		{
			"Weissle/persistent-breakpoints.nvim",
			opts = {
				load_breakpoints_event = { "BufReadPost" },
			},
		},
	},
	config = function()
		local sign = vim.fn.sign_define
		-- Nerd Font glyphs (UTF-8 byte escapes to survive editor serialization)
		sign("DapBreakpoint", { text = "\xef\x86\x92", texthl = "DapBreakpoint" }) -- nf-fa-circle
		sign("DapBreakpointCondition", { text = "\xef\x81\x95", texthl = "DapBreakpointCondition" }) -- nf-fa-question
		sign("DapBreakpointRejected", { text = "\xef\x97\xb3", texthl = "DiagnosticError" }) -- nf-cod-debug_breakpoint_unsupported
		sign("DapLogPoint", { text = "\xef\x80\xb1", texthl = "DapLogPoint" }) -- nf-fa-list
		sign("DapStopped", { text = "\xef\x81\x8b", texthl = "DiagnosticWarn", linehl = "DapStoppedLine" }) -- nf-fa-play

		-- Register dynamic description for mute/unmute keybind
		vim.schedule(function()
			local wk = require("which-key")
			wk.add({
				{
					"<leader>dm",
					desc = function()
						local pb_utils = require("persistent-breakpoints.utils")
						local normal_path = pb_utils.get_bps_path()
						local muted_path = normal_path:gsub("%.json$", ".muted.json")

						local muted_file = io.open(muted_path, "r")
						if muted_file then
							muted_file:close()
							return "🔇 Unmute All Breakpoints"
						else
							return "🔊 Mute All Breakpoints"
						end
					end,
				},
			})
		end)
	end,
}
