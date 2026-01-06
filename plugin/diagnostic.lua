vim.diagnostic.config({
    virtual_text = true,
    float = {
        focusable = false,
        scope = 'cursor',
    },
})

vim.diagnostic.handlers.loclist = {
    show = function(_, _, _, opts)
        opts.loclist.open = opts.loclist.open or false
        local winid = vim.api.nvim_get_current_win()
        vim.diagnostic.setloclist(opts.loclist)
        vim.api.nvim_set_current_win(winid)
    end,
    hide = function(_, _)
        vim.fn.setloclist(0, {})
    end,
}

vim.api.nvim_create_autocmd({
    'WinLeave',
    'CursorHold',
    'InsertLeave',
}, {
    pattern = nil,
    callback = function()
	    vim.diagnostic.open_float()
    end
})
