return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local config = require("nvim-treesitter")
        config.install({
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
        }):wait(30000)


        --     sync_install = false,
        --     indent = {
        --         enable = true,
        --     },
        --     highlight = {
        --         enable = true,
        --         additional_vim_regex_highlighting = { 'markdown' },
        --     },
        -- })
    end,
}
