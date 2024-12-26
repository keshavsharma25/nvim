return {
    'hedyhli/outline.nvim',
    lazy = false,
    cmd = { 'Outline', 'OutlineOpen' },
    config = function()
        require('outline').setup({})
        require('keshav.keymaps').outline()
    end,
}
