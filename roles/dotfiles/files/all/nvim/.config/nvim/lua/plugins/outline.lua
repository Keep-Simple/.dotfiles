return {
  "simrat39/symbols-outline.nvim",
  opts = {
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = false,
    position = "right",
    width = 35,
    autofold_depth = 0,
    auto_unfold_hover = false,
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
  },
  cmd = "SymbolsOutline",
  keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
}
