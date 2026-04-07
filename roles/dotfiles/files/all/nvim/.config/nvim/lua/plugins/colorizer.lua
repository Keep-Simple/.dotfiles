return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    filetypes = { "*" },
    options = {
      parsers = {
        css = true,
      },
      display = {
        mode = "background",
      },
    },
  },
}
