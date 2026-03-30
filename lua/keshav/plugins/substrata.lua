return {
    'kvrohit/substrata.nvim',
    lazy = true,
    -- priority = 1000,
    init = function()
        -- Set configuration options BEFORE loading the colorscheme
        -- All options from the README are listed here, uncomment and modify as needed.

        vim.g.substrata_italic_comments = false -- Default: true
        -- vim.g.substrata_italic_keywords = false -- Default: false
        -- vim.g.substrata_italic_booleans = false -- Default: false
        vim.g.substrata_italic_functions = true -- Example: make functions italic
        -- vim.g.substrata_italic_variables = false-- Default: false
        vim.g.substrata_transparent = true -- Default: false (set to true for transparent background)
        vim.g.substrata_variant = 'brighter' -- Default: "default" (can be "brighter")
    end,
    config = function()
        vim.cmd([[colorscheme substrata]])
    end,
}
