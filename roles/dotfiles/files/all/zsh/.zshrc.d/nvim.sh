nvim_restore_session_for_curr_dir() {
    nvim +"lua require('persistence').load(); vim.defer_fn(function() local b = vim.fn.getbufinfo({buflisted=1}); if #b <= 1 and (not b[1] or b[1].name == '') then Snacks.picker.smart() end end, 100)"
}

nvim_restore_last_session() {
    nvim +"lua require('persistence').load({ last = true })"
}
