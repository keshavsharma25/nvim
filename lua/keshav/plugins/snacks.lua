return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
        picker = { enabled = true },
        zen = { enabled = true },
        scratch = { enabled = true },
        notifier = { enabled = true },
        bufdelete = { enabled = true },
        rename = { enabled = true },
        gitbrowse = { enabled = true },
        lazygit = { enabled = true },
        terminal = { enabled = true },
        words = { enabled = true },
    },
    config = function(_, opts)
        require('snacks').setup(opts)
        require('keshav.keymaps').snacks()
    end,
}
