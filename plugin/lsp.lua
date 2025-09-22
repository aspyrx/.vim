vim.keymap.set({ 'v', 'n' }, '<leader>ca', function()
    vim.lsp.buf.code_action({
        apply = true,
    })
end)

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
            autotrigger = true,
        })
    end
})

