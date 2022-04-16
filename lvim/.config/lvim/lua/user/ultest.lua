local M = {}

M.config = function()
	-- require("ultest").setup({
	-- 	builders = {
	-- 		["python#pytest"] = function(cmd)
	-- 			-- The command can start with python command directly or an env manager
	-- 			local non_modules = { "python", "pipenv", "poetry" }
	-- 			-- Index of the python module to run the test.
	-- 			local module_index = 1
	-- 			if vim.tbl_contains(non_modules, cmd[1]) then
	-- 				module_index = 3
	-- 			end
	-- 			local module = cmd[module_index]

	-- 			-- Remaining elements are arguments to the module
	-- 			local args = vim.list_slice(cmd, module_index + 1)
	-- 			return {
	-- 				dap = {
	-- 					type = "python",
	-- 					request = "launch",
	-- 					module = module,
	-- 					args = args,
	-- 				},
	-- 			}
	-- 		end,
	-- 	},
	-- })

	vim.cmd([[
    let test#python#runner = 'pytest'
    let g:ultest_running_sign = '🏃'
    let test#javascript#reactscripts#options = "--watchAll=false"
    let test#python#pytest#options = "--color=yes"
    let test#javascript#jest#options = "--color=always"
    ]])
end

return M
