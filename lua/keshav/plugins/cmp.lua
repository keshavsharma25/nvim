return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'L3MON4D3/LuaSnip',
    },
    config = function()
        local luasnip = require('luasnip')
        local cmp = require('cmp')

        cmp.setup({
            event = 'InsertEnter',
            preselect = cmp.PreselectMode.None,
            completion = {
                completeopt = 'menu,menuone,noinsert',
            },
            experimental = {
                ghost_text = true,
            },
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
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer', keyword_length = 3 },
            },
            formatting = {
                format = function(entry, vim_item)
                    -- This assigns a visible tag to each source in the menu
                    vim_item.menu = ({
                        nvim_lsp = '[LSP]',
                        crates = '[Crates]',
                        buffer = '[Buffer]',
                        path = '[Path]',
                        luasnip = '[Snippet]',
                    })[entry.source.name]
                    return vim_item
                end,
            },
            sorting = {
                priority_weight = 5,
                comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.recently_used,
                    require('clangd_extensions.cmp_scores'), -- Clangd specific scoring
                    cmp.config.compare.score,
                    cmp.config.compare.locality,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline({
                ['<CR>'] = {
                    c = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ select = false })
                        else
                            fallback()
                        end
                    end,
                },
                ['<Space>'] = {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.confirm({
                                select = true,
                                behavior = cmp.ConfirmBehavior.Replace,
                            })
                        end
                        fallback()
                    end,
                },
            }),
            sources = cmp.config.sources({
                { name = 'path' },
            }, {
                { name = 'cmdline' },
            }),
        })
    end,
}
