return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local config = require('nvim-treesitter.configs')

        config.setup({
            modules = {},
            ignore_install = {},
            ensure_installed = {
                'bash',
                'c',
                'go',
                'javascript',
                'jsdoc',
                'lua',
                'python',
                'rust',
                'solidity',
                'sway',
                'typescript',
                'vimdoc',
                'html',
                'latex',
                'yaml',
            },
            sync_install = false, -- Set to true if you want it to block during install
            auto_install = true, -- Automatically install missing parsers when entering buffer

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { 'markdown' },
            },

            indent = {
                enable = true,
            },
        })
    end,
}
