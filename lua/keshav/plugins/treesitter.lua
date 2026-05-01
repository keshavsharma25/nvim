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
                    'sway',
                    'typescript',
                    'vimdoc',
                    'html',
                    'latex',
                    'typst',
                    'yaml',
                    'markdown',
                    'markdown_inline',
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
                    callback = function(args)
                        local ft = vim.bo[args.buf].filetype
                        if ft and ft ~= '' then
                            pcall(vim.treesitter.start, ft, args.buf)
                            -- Parse synchronously so trees are immediately available
                            local ok, parser = pcall(
                                vim.treesitter.get_parser,
                                args.buf,
                                ft,
                                { error = false }
                            )
                            if ok and parser then
                                pcall(parser.parse, parser)
                            end
                        end
                    end,
                }
            )
        end,
    },
}
