return {
    'hedyhli/markdown-toc.nvim',
    ft = 'markdown', -- Lazy load on markdown filetype
    cmd = { 'Mtoc' }, -- Or, lazy load on "Mtoc" command
    opts = {
        -- Your configuration here (optional)
        toc_list = {
            markers = { '*', '+', '-' },
            cycle_markers = true,
        },
    },
    config = function()
        require('mtoc').setup({})
        require('keshav.keymaps').mtoc()
    end,
}
