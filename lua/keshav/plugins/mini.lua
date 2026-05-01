return {
    -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    lazy = false,
    config = function()
        -- mini.ai
        local ai = require('mini.ai')

        -- Ensure parser is parsed before treesitter textobject queries
        local function with_parse(spec)
            return function(ai_type, ai_context, _)
                local ok, parser = pcall(
                    vim.treesitter.get_parser,
                    vim.api.nvim_get_current_buf(),
                    nil,
                    { error = false }
                )
                if ok and parser then
                    parser:parse()
                end
                return spec(ai_type, ai_context, _)
            end
        end

        ai.setup({
            n_lines = 500,
            custom_textobjects = {
                f = with_parse(ai.gen_spec.treesitter({
                    a = '@function.outer',
                    i = '@function.inner',
                })),
                a = with_parse(ai.gen_spec.treesitter({
                    a = '@parameter.outer',
                    i = '@parameter.inner',
                })),
                c = with_parse(ai.gen_spec.treesitter({
                    a = '@class.outer',
                    i = '@class.inner',
                })),
            },
        })

        -- mini.surround
        require('mini.surround').setup({})

        -- mini.sessions
        require('mini.sessions').setup({
            autoread = true,
            autowrite = true,
            directory = vim.fn.stdpath('data') .. '/sessions',
            file = 'Session.vim',
            verbose = { read = true, write = true },
        })

        require('keshav.keymaps').mini_sessions()
    end,
}
