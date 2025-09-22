-- allow tab to complete
local regex_space = vim.regex('^\\s$')
vim.keymap.set({ 'i' }, '<Tab>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-y>' -- enter selected completion
    end

    local col = vim.fn.col('.') - 1
    if col <= 0 then
        return '<Tab>' -- start of line
    end

    local line = vim.fn.getline('.')
    local prev = string.sub(line, col, col)
    if col <= 0 or regex_space:match_str(prev) then
        return '<Tab>' -- at whitespace
    end

    if vim.opt_local.omnifunc:get() ~= '' then
        return '<C-X><C-O>'     -- omni-complete
    end
    if vim.opt_local.completefunc:get() ~= '' then
        return '<C-X><C-U>'     -- user-complete
    end

    -- no completion available, try generic completion
    return '<C-N>'
end, { silent = true, expr = true })

