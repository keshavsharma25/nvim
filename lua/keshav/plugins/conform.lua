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
            yaml = { 'prettierd' },
            ['*'] = { 'trim_whitespace' },
        },
        format_after_save = {
            lsp_format = 'fallback',
        },
    },
    config = function(_, opts)
        require('conform').setup(opts)

        vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = '*.lua',
            group = vim.api.nvim_create_augroup(
                'ConformLuaFormat',
                { clear = true }
            ),
            callback = function(args)
                require('conform').format({
                    bufnr = args.buf,
                    async = false, -- Sync for save to avoid partial writes
                    timeout_ms = 1000,
                    lsp_fallback = true,
                })
            end,
        })
    end,
}
