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
        notify_on_error = true,
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
        formatters_by_ft = {
            lua = { 'stylua' },
            go = { 'goimports', 'gofmt' },
            rust = { 'rustfmt', lsp_format = 'fallback' },
            python = { 'ruff' },
            javascript = { 'biome', 'prettierd', stop_after_first = true },
            typescript = { 'biome', 'prettierd', stop_after_first = true },
            typescriptreact = { 'prettierd', 'biome', stop_after_first = true },
            json = { 'prettierd' },
            markdown = { 'markdownlint' },
            ['*'] = { 'trim_whitespace' },
        },
        format_after_save = {
            lsp_format = 'fallback',
        },
    },
    config = function(_, opts)
        require('conform').setup(opts)
    end,
}
