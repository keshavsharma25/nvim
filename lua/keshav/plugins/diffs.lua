return {
    url = 'https://forge.barrettruth.com/barrettruth/diffs.nvim',
    name = 'diffs.nvim',
    config = function()
        vim.g.diffs = {
            integrations = {
                fugitive = true,
                gitsigns = true,
            },
        }
    end,
}
