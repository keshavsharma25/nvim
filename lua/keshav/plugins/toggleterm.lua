return {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
        require('toggleterm').setup({})
        require('keshav.keymaps').toggle_term()
    end,
}
