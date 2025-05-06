return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	keys = {
		{ "<leader>aC", "<cmd>AvanteClear<cr>", desc = "Clear chat" },
	},
	version = false, -- Never set this value to "*"! Never!
	opts = {
		provider = "copilot", -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
		copilot = {
			model = "claude-3.7-sonnet",
		},
		behaviour = {
			auto_focus_sidebar = true,
			auto_suggestions = false, -- Experimental stage
			auto_suggestions_respect_ignore = false,
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			jump_result_buffer_on_finish = false,
			support_paste_from_clipboard = true,
			minimize_diff = true,
			enable_token_counting = false,
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
		mappings = {
			--- @class AvanteConflictMappings
			diff = {
				ours = "co",
				theirs = "ct",
				all_theirs = "ca",
				both = "cb",
				cursor = "cc",
				next = "]x",
				prev = "[x",
			},
			jump = {
				next = "]]",
				prev = "[[",
			},
			submit = {
				normal = "<CR>",
				insert = "<C-s>",
			},
			cancel = {
				normal = { "<C-c>", "<Esc>", "q" },
				insert = { "<C-c>" },
			},
			sidebar = {
				apply_all = "A",
				apply_cursor = "a",
				retry_user_request = "r",
				edit_user_request = "e",
				switch_windows = "<Tab>",
				reverse_switch_windows = "<S-Tab>",
				remove_file = "d",
				add_file = "@",
				close = { "<Esc>", "q" },
				close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
			},
		},
		hints = { enabled = true },
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
							name = "Avante",
							opts = {},
						},
					},
				},
			},
		},
	},
}
