return {
    'OXY2DEV/markview.nvim',
    lazy = false,
    opts = {
        preview = {
            icon_provider = 'devicons', -- "mini" or "devicons"
            hybrid_modes = { 'n' },
            linewise_hybrid_mode = true,
        },
    },
    config = function (_, opts)
        require('markview').setup(opts)
        require('keshav.keymaps').markview()
    end
}
