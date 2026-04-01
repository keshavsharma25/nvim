return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
        require('which-key').setup()

        require('which-key').add({
            { '<leader>c', group = 'Color Column | Rename current file' },
            { '<leader>a', group = 'Harpoon: [A]dd to [l]ist' },
            { '<leader>h', group = 'Harpoon: Traverse&Explore' },
            { '<leader>x', group = 'Harpoon: Replace' },
            { '<leader>l', group = 'LSP' },
            { '<leader>s', group = 'Picker' },
            { '<leader>t', group = 'Trouble' },
            { '<leader>b', group = 'Buffer' },
            { '<leader>g', group = 'Git Browse' },
            { '<leader>w', group = 'Mini.Sessions' },
            { '<leader>o', group = 'Outline' },
        })
    end,
}
