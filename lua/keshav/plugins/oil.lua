return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        watch_for_changes = true,
        view_options = {
            show_hidden = true,
        },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
}
