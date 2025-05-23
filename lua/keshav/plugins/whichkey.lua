return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
        require('which-key').setup()

        require('which-key').add({
            { '<leader>l', group = 'LSP' },
            { '<leader>s', group = 'Telescope' },
            { '<leader>t', group = 'Trouble' },
            { '<leader>g', group = 'LazyGit' },
            { '<leader>h', group = 'harpoon: Add&Explore' },
            { '<leader>x', group = 'harpoon: Replace' },
        })
    end,
}
