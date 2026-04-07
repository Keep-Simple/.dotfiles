return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			-- snyk_ls = {
			-- 	init_options = {
			-- 		activateSnykCode = "true",
			-- 		trustedFolders = {
			-- 			os.getenv("HOME") .. "/Documents",
			-- 		},
			-- 	},
			-- },
			snyk_ls = false,
		},
	},
}
