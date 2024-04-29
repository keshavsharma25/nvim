return {
    -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
        {
            '<F3>',
            function()
                require('conform').format({ async = false, lsp_fallback = true })
            end,
            mode = { 'n', 'v' },
            desc = 'Conform: Format buffer',
        },
    },
    opts = {
        notify_on_error = false,
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
        formatters_by_ft = {
            lua = { 'stylua' },
            go = { 'goimports', 'gofmt' },
            rust = { 'rustfmt' },
            python = { 'ruff_fix', 'ruff_format' },
            javascript = { { 'prettierd', 'biome' } },
            typescript = { { 'prettierd', 'biome' } },
            typescriptreact = { { 'prettierd', 'biome' } },
            solidity = { 'prettier_solidity' },
            json = { 'prettier' },
            ['*'] = { 'trim_whitespace' },
        },
        formattters = {},
    },
    config = function(_, opts)
        require('conform').setup(opts)

        local solidity_formatter =
            vim.deepcopy(require('conform.formatters.prettier'))
        require('conform.util').add_formatter_args(solidity_formatter, {
            '--stdin-filepath',
            '--plugin=prettier-plugin-solidity',
        }, { append = false })
        require('conform').formatters.prettier_solidity = solidity_formatter
    end,
}
