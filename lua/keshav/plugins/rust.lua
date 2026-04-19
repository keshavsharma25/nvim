return {
    'mrcjkb/rustaceanvim',
    version = '^9',
    lazy = false,
    ft = 'rust',
    init = function()
        vim.g.rustaceanvim = {
            server = {
                settings = {
                    ['rust-analyzer'] = {
                        cargo = {
                            allFeatures = true,
                        },
                        checkOnSave = {
                            command = 'clippy',
                        },
                    },
                },
            },
            tools = {
                auto_set_html_theme = false,
            },
            dap = {
                adapter = {
                    type = 'server',
                    port = '${port}',
                    executable = {
                        command = 'codelldb',
                        args = { '--port', '${port}' },
                    },
                },
            },
        }
    end,
}
