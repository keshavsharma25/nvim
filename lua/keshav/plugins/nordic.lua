return {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('nordic').setup({
            transparent_bg = true,
            telescope = {
                -- Available styles: `classic`, `flat`.
                styles = 'classic',
            },
            ts_context = {
                -- Enables dark background for treesitter-context window
                dark_background = true,
            },
        })

        require('nordic').load()
    end,
}
