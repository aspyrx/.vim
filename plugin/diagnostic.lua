vim.diagnostic.config({
    virtual_text = true,
    float = {
        border = 'rounded',
        focusable = false,
        scope = 'cursor',
        style = 'minimal',
    },
})

vim.diagnostic.handlers.loclist = {
    show = function(_, _, _, opts)
        local winid = vim.api.nvim_get_current_win()
        vim.diagnostic.setloclist({
            open = false,
        })
        vim.api.nvim_set_current_win(winid)
    end
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
