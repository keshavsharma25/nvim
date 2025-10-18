return {
    -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    lazy = false,
    config = function()
        -- mini.ai
        require('mini.ai').setup({ n_lines = 500 })

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
