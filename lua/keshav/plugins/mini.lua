return {
    -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    lazy = false,
    config = function()
        -- mini.ai
        local ai = require('mini.ai')

        ai.setup({
            n_lines = 500,
            custom_textobjects = {
                -- Mapping 'f' to functions
                f = ai.gen_spec.treesitter({
                    a = '@function.outer',
                    i = '@function.inner',
                }),
                -- Mapping 'a' to arguments/parameters
                a = ai.gen_spec.treesitter({
                    a = '@parameter.outer',
                    i = '@parameter.inner',
                }),
                -- Mapping 'c' to classes
                c = ai.gen_spec.treesitter({
                    a = '@class.outer',
                    i = '@class.inner',
                }),
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
