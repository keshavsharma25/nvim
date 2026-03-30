return {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    -- priority = 1000,
    config = function()
        local nordic = require('nordic')
        nordic.setup({})

        local options = {
            transparent = {
                bg = true,
                float = true,
            },
            on_palette = function(palette) end,
            -- This callback can be used to override the colors used in the extended palette.
            after_palette = function(palette) end,
            -- This callback can be used to override highlights before they are applied.
            on_highlight = function(highlights, palette) end,
            bright_border = true,
            bold_keywords = true,
            italic_comments = true,
            noice = {
                -- Available styles: `classic`, `flat`.
                style = 'flat',
            },
            ts_context = {
                -- Enables dark background for treesitter-context window
                dark_background = true,
            },
        }

        nordic.load(options)
    end,
}
