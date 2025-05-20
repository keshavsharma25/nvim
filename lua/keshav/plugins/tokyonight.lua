return {
    'folke/tokyonight.nvim',
    lazy = true,
    -- priority = 1000,
    config = function()
        require('tokyonight').setup({
            style = 'moon',
            light_style = 'day',
            transparent = true,
            terminal_colors = true,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
                functions = {},
                variables = {},
                sidebars = 'dark',
                floats = 'dark',
            },
            sidebars = { 'qf', 'help' },
            day_brightness = 0.2,
            hide_inactive_statusline = false,
            dim_inactive = false,
            lualine_bold = false,
        })

        vim.cmd.hi('Comment gui=none')
        vim.cmd.colorscheme('tokyonight-moon')
    end,
}
