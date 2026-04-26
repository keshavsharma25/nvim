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
                    },
                },
            },
            tools = {
                auto_set_html_theme = false,
                float_win_config = {
                    border = 'rounded',
                },
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
