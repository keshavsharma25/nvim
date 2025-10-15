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
                'yaml-language-server',
            }

            local fmters = {
                'prettierd',
                'stylua',
                'goimports',
                'markdownlint',
                'delve',
                'yamlfmt',
            }

            require('mason').setup({
                ensure_installed = fmters,
            })

            vim.lsp.config('*', {
                capabilities = capabilities,
            })

            vim.lsp.config('lua_ls', {
                on_init = function(client)
                    client.server_capabilities.documentFormattingProvider =
                        false
                    client.server_capabilities.documentRangeFormattingProvider =
                        false
                end,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }, -- Optional, for vim globals
                        },
                    },
                },
            })

            -- Specific configs for ts_ls and biome
            vim.lsp.config('ts_ls', {
                root_markers = {
                    'tsconfig.json',
                    'jsconfig.json',
                    'package.json',
                    '.git',
                },
                single_file_support = false,
            })

            vim.lsp.config('biome', {
                root_markers = { 'biome.json', 'biome.jsonc' },
                single_file_support = true,
            })

            -- Add pyright-specific config for uv .venv detection
            vim.lsp.config('pyright', {
                before_init = function(params, config)
                    -- Dynamically find .venv upward from workspace root
                    local venv_path = vim.fs.find({ '.venv' }, {
                        upward = true,
                        path = params.root_dir,
                        type = 'directory',
                    })[1]
                    if venv_path then
                        config.settings.python.pythonPath = venv_path
                            .. '/bin/python'
                    end
                end,
                settings = {
                    python = {
                        analysis = {
                            autoImportCompletions = true,
                            diagnosticMode = 'workspace',
                        },
                    },
                },
            })

            require('mason-lspconfig').setup({
                ensure_installed = servers,
            })

            vim.lsp.enable(servers)

            local function setup_python(client)
                -- Configure Python specific settings
                if client.name == 'pyright' then
                    -- Configure pyright specific settings
                    -- Let ruff handle formatting
                    client.server_capabilities.documentFormattingProvider =
                        false
                end
                if client.name == 'ruff' then
                    -- Configure Ruff specific settings
                    client.server_capabilities.hoverProvider = false -- Let pyright handle hover
                end
            end

            -- Check if the formatter is Biome or Prettier
            local function get_formatter(bufnr)
                bufnr = bufnr or 0

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
                return vim.fs.root(bufnr, prettier_files) and 'prettierd'
                    or 'biome'
            end

            local function setup_ts(client, bufnr)
                if client.name == 'ts_ls' then
                    client.server_capabilities.documentFormattingProvider =
                        false -- Let biome handle formatting
                end
                if client.name == 'biome' then
                    if get_formatter(bufnr) == 'prettierd' then
                        client.server_capabilities.documentFormattingProvider =
                            false -- Let prettier handle formatting
                    end
                end
            end

            local conform = require('conform')

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
                                        filter = function(client)
                                            return client.name == 'ruff'
                                        end,
                                        bufnr = args.buf,
                                    })
                                end,
                            })
                        end
                    end

                    if cl.name == 'ts_ls' or cl.name == 'biome' then
                        setup_ts(cl, args.buf)

                        -- Setup Typescript specific autocommands
                        if not vim.b[args.buf].ts_format_set then
                            vim.b[args.buf].ts_format_set = true
                            vim.api.nvim_create_autocmd('BufWritePre', {
                                group = lsp_group,
                                buffer = args.buf,
                                callback = function()
                                    local formatter = get_formatter(args.buf)
                                    if formatter == 'prettierd' then
                                        conform.format({
                                            formatters = { 'prettierd' },
                                            bufnr = args.buf,
                                        })
                                    else
                                        -- Format on save using the LSP
                                        vim.lsp.buf.format({
                                            filter = function(client)
                                                return client.name == formatter
                                            end,
                                            bufnr = args.buf,
                                        })
                                    end
                                end,
                            })
                        end
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

            -- Optionally setup conform if needed globally
            conform.setup({
                -- Add global formatters if necessary
            })
        end,
    },
}
