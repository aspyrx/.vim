local cmp = require 'cmp'
local cmp_buffer = require 'cmp_buffer'

local regex_space = vim.regex('^\\s$')
function tab_complete(fallback)
    -- Smart tab-complete (fallback on whitespace/start of line).
    if cmp.visible() then
        cmp.complete_common_string()
        return
    end

    local col = vim.fn.col('.') - 1
    if col <= 0 then
        fallback()  -- start of line
        return
    end

    local line = vim.fn.getline('.')
    local prev = string.sub(line, col, col)
    if col <= 0 or regex_space:match_str(prev) then
        fallback()  -- at whitespace
        return
    end

    cmp.complete()
end

-- `nvim-cmp` setup
cmp.setup({
    experimental = {
        ghost_text = true,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = tab_complete,
    }),
    snippet = {
        expand = function(args)
            -- use native Neovim snippets
            vim.snippet.expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        {
            -- from 'cmp-nvim-lsp'
            name = 'nvim_lsp'
        },
    }, {
        {
            -- from 'cmp-buffer'
            name = 'buffer',
            option = {
                -- match all keywords (cf. option `iskeyword`)
                keyword_pattern = [[\k\+]]
            },
        },
    }),
    sorting = {
        comparators = {
            -- suggest results near the current line
            function(...) return cmp_buffer:compare_locality(...) end,
        }
    },
    view = {
        entries = "native",
    },
})

