return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local config = require('nvim-treesitter.config')

            config.setup({
                modules = {},
                ignore_install = {},
                ensure_installed = {
                    'bash',
                    'c',
                    'comment',
                    'go',
                    'javascript',
                    'jsdoc',
                    'lua',
                    'python',
                    'rust',
                    'solidity',
                    'typescript',
                    'vimdoc',
                    'html',
                    'latex',
                    'typst',
                    'toml',
                    'yaml',
                    'markdown',
                    'markdown_inline',
                    'nim',
                },
                install_dir = vim.fn.stdpath('data'),
                sync_install = false,
                auto_install = true,
                indent = {
                    enable = true,
                },
            })

            -- nvim-treesitter main branch removed the highlight module.
            -- Use Neovim built-in treesitter highlighting and force parse.
            vim.api.nvim_create_autocmd(
                { 'BufRead', 'BufNewFile', 'BufWinEnter' },
                {
                    group = vim.api.nvim_create_augroup(
                        'TS_Highlight_Fallback',
                        { clear = true }
                    ),
                    callback = function(args)
                        local buf = args.buf
                        local ft = vim.bo[buf].filetype

                        if ft and ft ~= '' then
                            -- Safely map the filetype to the treesitter language name
                            local lang = vim.treesitter.language.get_lang(ft)
                                or ft

                            -- Correct argument order: buffer number, then language
                            pcall(vim.treesitter.start, buf, lang)
                        end
                    end,
                }
            )
        end,
    },
}
