return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            {
                'folke/lazydev.nvim',
                ft = 'lua', -- only load on lua files
                opts = {
                    library = {
                        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                    },
                },
            },
            { -- optional cmp completion source for require statements and module annotations
                'hrsh7th/nvim-cmp',
                opts = function(_, opts)
                    opts.sources = opts.sources or {}
                    table.insert(opts.sources, {
                        name = 'lazydev',
                        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
                    })
                end,
            },
            'hrsh7th/cmp-nvim-lsp',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
            'j-hui/fidget.nvim',
            'stevearc/conform.nvim',
            { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' },
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
            local lspconfig = require('lspconfig')
            local lsp_keymaps = require('keshav.keymaps')

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local lsp_group =
                vim.api.nvim_create_augroup('LspConfig', { clear = true })

            local servers = {
                'clangd',
                'lua_ls',
                'ruff',
                'pyright',
                'biome',
                'ts_ls',
                'taplo',
                'gopls',
                'marksman',
            }

            local fmters = { 'prettierd', 'markdownlint', 'delve' }

            require('mason').setup({
                ensure_installed = fmters,
                automatic_installation = false,
            })

            require('mason-lspconfig').setup({
                ensure_installed = servers,
                automatic_installation = false,
            })

            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup({
                    -- on_attach = my_custom_on_attach,
                    capabilities = capabilities,
                })
            end

            local function setup_python(client)
                -- Configure Python specific settings
                if client.name == 'pyright' then
                    -- Configure pyright specific settings
                    client.server_capabilities.documentFormattingProvider =
                        false -- Let ruff handle formatting
                end

                if client.name == 'ruff' then
                    -- Configure Ruff specific settings
                    client.server_capabilities.hoverProvider = false -- Let pyright handle hover
                end
            end

            -- Check if the formatter is Biome or Prettier
            local function get_formatter()
                -- Check for Prettier config files
                local prettier_files = {
                    '.prettierrc',
                    '.prettierrc.json',
                    '.prettierrc.yml',
                    '.prettierrc.yaml',
                    '.prettierrc.json5',
                    '.prettierrc.js',
                    'prettier.config.js',
                    'package.json',
                }

                return vim.lsp.util.root_pattern(unpack(prettier_files))(
                    vim.fn.getcwd()
                ) and 'prettierd' or 'biome'
            end

            local function setup_ts(client)
                if client.name == 'ts_ls' then
                    client.server_capabilities.documentFormattingProvider =
                        false -- Let biome handle formatting

                    local lsp_util = require('lspconfig.util')

                    client.root_dir = lsp_util.root_pattern(
                        'tsconfig.json',
                        'jsconfig.json',
                        'package.json',
                        '.git'
                    )

                    client.single_file = false
                end

                if client.name == 'biome' then
                    client.root_dir =
                        vim.lsp.util.root_pattern('biome.json', 'biome.jsonc')

                    client.single_file_support = true

                    if get_formatter() == 'prettierd' then
                        client.server_capabilities.documentFormattingProvider =
                            false -- Let prettier handle formatting
                    end
                end
            end

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local cl = vim.lsp.get_client_by_id(args.data.client_id)

                    if not cl or not cl.server_capabilities then
                        return
                    end

                    -- Enable inlay hints if supported
                    if cl.server_capabilities.inlayHintProvider then
                        vim.lsp.inlay_hint.enable(true)
                    end

                    lsp_keymaps.lsp(args)

                    -- Python (pyright, ruff) on LspAttach config
                    if cl.name == 'pyright' or cl.name == 'ruff' then
                        setup_python(cl)

                        -- Setup Python specific autocommands
                        if cl.name == 'ruff' then
                            vim.api.nvim_create_autocmd('BufWritePre', {
                                group = lsp_group,
                                buffer = args.buf,
                                callback = function()
                                    -- Format on save using the LSP
                                    vim.lsp.buf.format({
                                        filter = function()
                                            return cl.name == 'ruff'
                                        end,
                                        bufnr = args.buf,
                                    })
                                end,
                            })
                        end
                    end

                    if cl.name == 'ts_ls' then
                        setup_ts(cl)

                        -- Setup Typescript specific autocommands
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            group = lsp_group,
                            buffer = args.buf,
                            callback = function()
                                -- Format on save using the LSP
                                vim.lsp.buf.format({
                                    filter = function()
                                        -- Prefer biome for formatting
                                        return cl.name == get_formatter()
                                    end,
                                    bufnr = args.buf,
                                })
                            end,
                        })
                    end
                end,
            })

            local luasnip = require('luasnip')
            local cmp = require('cmp')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ['<C-n>'] = cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    ['<C-p>'] = cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    ['<CR>'] = cmp.mapping(
                        cmp.mapping.confirm({
                            behavior = cmp.ConfirmBehavior.Insert,
                            select = true,
                        }),
                        { 'i', 'c' }
                    ),
                    ['<C-Space>'] = cmp.mapping.complete({}),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
            })
        end,
    },
}
