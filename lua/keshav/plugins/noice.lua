return {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'hrsh7th/nvim-cmp',
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        -- 'rcarriga/nvim-notify',
    },
    config = function()
        require('noice').setup({
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = false, -- use a classic bottom cmdline for search
                command_palette = false, -- position the cmdline and popupmenu together
                long_message_to_split = false, -- long messages will be sent to a split
                lsp_doc_border = true, -- add a border to hover docs and signature help
            },
            cmdline = {
                enabled = true,
                view = 'cmdline',
                cmdline = { pattern = '^:', icon = '', lang = 'vim' },
            },
        })
    end,
}
