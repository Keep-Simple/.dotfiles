-- snyk-ls: per-project debug attach helper.
-- Trust with `:trust` after first load. Loaded via vim.o.exrc.

local BINARY_NAME = "snyk-macos-arm64"

local function list_pids(name)
	local out = vim.fn.systemlist({ "pgrep", "-f", name })
	if vim.v.shell_error ~= 0 then
		return {}
	end
	local self_pid = tostring(vim.fn.getpid())
	local pids = {}
	for _, line in ipairs(out) do
		local pid = vim.trim(line)
		if pid ~= "" and pid ~= self_pid then
			table.insert(pids, pid)
		end
	end
	return pids
end

local function describe(pids)
	if #pids == 0 then
		return {}
	end
	local args = { "ps", "-o", "pid=,etime=,command=", "-p", table.concat(pids, ",") }
	local out = vim.fn.systemlist(args)
	if vim.v.shell_error ~= 0 then
		return {}
	end
	local rows = {}
	for _, line in ipairs(out) do
		local pid, etime, cmd = line:match("^%s*(%d+)%s+(%S+)%s+(.+)$")
		if pid then
			table.insert(rows, { pid = tonumber(pid), etime = etime, cmd = cmd })
		end
	end
	return rows
end

local function pick()
	local pids = list_pids(BINARY_NAME)
	if #pids == 0 then
		vim.notify("No " .. BINARY_NAME .. " process running", vim.log.levels.WARN)
		return require("dap").ABORT
	end
	local rows = describe(pids)
	if #rows == 1 then
		return rows[1].pid
	end
	local choice = nil
	local done = false
	vim.ui.select(rows, {
		prompt = "Attach to " .. BINARY_NAME .. ":",
		format_item = function(r)
			return string.format("pid=%d  age=%s  %s", r.pid, r.etime, r.cmd)
		end,
	}, function(item)
		choice = item
		done = true
	end)
	vim.wait(60000, function()
		return done
	end)
	if not choice then
		return require("dap").ABORT
	end
	return choice.pid
end

vim.keymap.set("n", "<leader>dA", function()
	require("dap").run({
		type = "go",
		name = "Attach " .. BINARY_NAME,
		mode = "local",
		request = "attach",
		processId = pick,
	})
end, { desc = "Attach to " .. BINARY_NAME })
