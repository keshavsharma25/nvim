return {
    'selimacerbas/mdkite.nvim',
    dependencies = {
        { 'selimacerbas/kitehost.nvim', version = '>=2.0.0' },
    },
    cmd = { 'MdKite' },
    ft = { 'markdown', 'mermaid' },
    config = function()
        require('mdkite').setup({
            port = 2999,
            host = '127.0.0.1',
            -- Rust is optional; use browser-side Mermaid until mmdr is installed.
            mermaid_renderer = vim.fn.executable('mmdr') == 1 and 'rust' or 'js',
        })
    end,
}
