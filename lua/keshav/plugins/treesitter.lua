return {
    'nvim-treesitter/nvim-treesitter',
    name = 'nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup({
            -- A list of parser names, or "all"
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
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = true,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
            auto_install = false,

            indent = {
                enable = true,
            },

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = { 'markdown' },
            },
            ignore_install = {},
            modules = {},
        })
    end,
}
