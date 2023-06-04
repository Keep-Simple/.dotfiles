local util = require("lspconfig/util")
local path = util.path

local function get_python_path(workspace)
	-- Use activated virtualenv.
	if vim.env.VIRTUAL_ENV then
		return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
	end

	-- Find and use virtualenv in workspace directory.
	for _, pattern in ipairs({ "*", ".*" }) do
		local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
		if match ~= "" then
			return path.join(path.dirname(match), "bin", "python")
		end
		match = vim.fn.glob(path.join(workspace, "pyproject.toml"))
		if match ~= "" then
			local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
			if venv then
				return path.join(venv, "bin", "python")
			end
		end
	end

	-- Fallback to system Python.
	return exepath("python3") or exepath("python") or "python"
end

local opts = {
	root_dir = function(fname)
		local root_files = {
			"pyproject.toml",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
			"pyrightconfig.json",
		}
		return util.root_pattern(unpack(root_files))(fname) or util.find_git_ansector(fname)
	end,
	single_file_support = true,
	on_init = function(client)
		local _path = get_python_path(client.config.root_dir)
		client.config.settings =
			vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = _path } })
	end,
}

require("lvim.lsp.manager").setup("pyright", opts)
