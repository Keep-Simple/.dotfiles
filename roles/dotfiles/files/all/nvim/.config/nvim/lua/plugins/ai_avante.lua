return {
	"yetone/avante.nvim",
	build = "make",
	event = "VeryLazy",
	keys = {
		{
			"<leader>aC",
			"<cmd>AvanteClear<cr>",
			desc = "Clear Chat",
		},
	},
	version = false,
	opts = {
		instructions_file = "avante.md",
		providers = {
			copilot = {
				model = "claude-sonnet-4",
			},
		},
		provider = "gemini-cli", -- acp provider (use nvim as wrapper to gemini-cli/claude-code)
		-- provider = "copilot", -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
		behaviour = {
			auto_focus_sidebar = false,
			auto_suggestions = false, -- Experimental stage
			auto_suggestions_respect_ignore = false,
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			jump_result_buffer_on_finish = false,
			support_paste_from_clipboard = true,
			minimize_diff = true,
			enable_token_counting = true,
			enable_cursor_planning_mode = false,
			enable_claude_text_editor_tool_mode = false,
			use_cwd_as_project_root = true,
			auto_focus_on_diff_view = false,
		},
		rag_service = {
			enabled = false,
			host_mount = os.getenv("HOME"), -- Host mount path for the rag service
			runner = "nix", -- The runner for the rag service, (can use docker, or nix)
			provider = "ollama", -- The provider to use for RAG service (e.g. openai or ollama)
			llm_model = "llama3", -- The LLM model to use for RAG service
			embed_model = "nomic-embed-text", -- The embedding model to use for RAG service
			endpoint = "http://localhost:11434",
		},
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			dependencies = { "folke/snacks.nvim" },
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
		{
			"saghen/blink.cmp",
			dependencies = {
				"Kaiser-Yang/blink-cmp-avante",
			},
			opts = {
				sources = {
					default = { "avante", "lsp", "path", "snippets", "buffer" },
					providers = {
						avante = {
							module = "blink-cmp-avante",
							name = "avante",
						},
					},
				},
			},
		},
	},
}
