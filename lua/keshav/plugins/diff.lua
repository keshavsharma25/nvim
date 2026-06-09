return {
    'barrettruth/diffs.nvim',
    config = function()
        vim.g.diffs = {
            integrations = {
                fugitive = true,
            },
        }
    end,
}
