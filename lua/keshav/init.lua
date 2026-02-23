require('keshav.options')
require('keshav.lazyload')
require('keshav.sway')

local K = require('keshav.keymaps')

if not vim.treesitter.language.ft_to_lang then
    vim.treesitter.language.ft_to_lang = function(ft)
        return vim.treesitter.language.get_lang(ft) or ft
    end
end

K.init()
K.preventMs()
K.markdown()

local keshavGroup = vim.api.nvim_create_augroup('Keshav', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = keshavGroup,
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Clear whitespaces at the end of line',
    group = keshavGroup,
    pattern = '*',
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
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
