return {
    'ThePrimeagen/harpoon',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    branch = 'harpoon2',
    config = function()
        local harpoon = require('harpoon')

        harpoon:setup()

        require('keshav.keymaps').harpoon()
    end,
}
