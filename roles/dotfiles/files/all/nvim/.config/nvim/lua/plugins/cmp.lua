return {
	"saghen/blink.cmp",
	opts = {
		keymap = {
			["<C-space>"] = {},
			["<C-j>"] = { "show", "select_next", "fallback" },
			["<C-k>"] = { "show", "select_prev", "fallback" },
		},
		documentation = {
			auto_show = true,
		},
		completion = {
			trigger = {
				show_on_insert_on_trigger_character = false,
				show_on_accept_on_trigger_character = false,
				show_in_snippet = false,
				show_on_keyword = false,
				show_on_trigger_character = false,
			},
		},
	},
}
