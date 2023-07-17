return {
	"ahmedkhalf/project.nvim",
	opts = {
		detection_methods = { "pattern", "lsp" },
		patterns = {
			".git",
			"_darcs",
			".hg",
			".bzr",
			".svn",
			"Makefile",
			"package.json",
			"pom.xml",
			".root",
			"pyproject.toml",
		},
	},
	event = "VeryLazy",
	config = function(_, opts)
		require("project_nvim").setup(opts)
		require("telescope").load_extension("projects")
	end,
}
