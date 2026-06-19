return {
    'folke/trouble.nvim',
    lazy = false,
    config = function()
        require('trouble').setup({})
        require('keshav.keymaps').trouble()
    end,
}
