return {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'hrsh7th/nvim-cmp',
    },
    config = function()
        require('noice').setup({
            routes = {
                {
                    filter = {
                        event = 'notify',
                        find = 'No information available',
                    },
                    opts = { skip = true },
                },
            },
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = false,
                long_message_to_split = false,
                lsp_doc_border = true,
            },
            views = {
                hover = {
                    size = { max_width = math.floor(vim.o.columns * 0.8) },
                    position = { row = 2, col = 0 },
                    border = {
                        style = 'rounded',
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = { FloatBorder = 'WhiteHoverBorder' },
                        wrap = true,
                        linebreak = true,
                    },
                },
            },
            cmdline = {
                enabled = true,
                view = 'cmdline',
                cmdline = { pattern = '^:', icon = '', lang = 'vim' },
            },
            notify = {
                enabled = true,
                view = 'notify',
            },
        })
    end,
}
