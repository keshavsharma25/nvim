return {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
        vim.fn['mkdp#util#install']()
    end,
    init = function()
        vim.g.mkdp_filetypes = { 'markdown' }
        vim.g.mkdp_port = '2999'

        vim.g.mkdp_markdown_css = vim.fn.expand('~/.config/nvim/utils/mkdp-custom.css')
    end,
}
