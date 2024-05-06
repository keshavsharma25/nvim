return {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable('make') == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
        require('telescope').setup({
            extensions = {
                ['ui-select'] = { require('telescope.themes').get_dropdown() },
            },
            defaults = {
                mappings = {
                    n = {
                        ['q'] = require('telescope.actions').close,
                    },
                },
            },
        })

        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        require('keshav.keymaps').telescope()
    end,
}
