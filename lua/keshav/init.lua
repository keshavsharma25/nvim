require('keshav.options')
require('keshav.lazyload')
require('keshav.sway')

local K = require('keshav.keymaps')

K.init()
K.preventMs()
K.markdown()

local keshavGroup = vim.api.nvim_create_augroup('Keshav', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = keshavGroup,
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Clear whitespaces at the end of line',
    group = keshavGroup,
    pattern = '*',
    command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP Attach',
    group = keshavGroup,
    callback = function(e)
        K.lsp(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = e.buf,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = e.buf,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})
