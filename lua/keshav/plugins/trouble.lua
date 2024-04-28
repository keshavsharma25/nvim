return {
    "folke/trouble.nvim",
    config = function()
        require('trouble').setup({})
        require('keshav.keymaps').trouble()
    end
}
