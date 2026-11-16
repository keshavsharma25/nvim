return {
    -- "gc" to comment visual regions/lines
    'numToStr/Comment.nvim',
    lazy = false,
    opts = {
        pre_hook = function(ctx)
            -- Avoid Tree-sitter detection when Lean has no available parser.
            if vim.bo.filetype == 'lean' then
                local ctype = require('Comment.utils').ctype
                return ctx.ctype == ctype.blockwise and '/-%s-/' or '--%s'
            end
        end,
    },
}
