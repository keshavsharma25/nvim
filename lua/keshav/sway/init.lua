local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')

-- Check if the config is already defined (useful when reloading this file)
if not configs.sway_lsp then
    configs.sway_lsp = {
        default_config = {
            cmd = { 'forc-lsp' },
            filetypes = { 'sway' },
            root_dir = function(fname)
                return lspconfig.util.find_git_ancestor(fname)
            end,
            settings = {},
        },
    }
end

lspconfig.sway_lsp.setup({})
