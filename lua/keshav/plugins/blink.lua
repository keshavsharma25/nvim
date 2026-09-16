return {
    'saghen/blink.cmp',
    -- Pin to v1 releases for now
    version = '1.*',
    lazy = false,
    dependencies = {
        -- Blink supports LuaSnip directly as a snippet preset (needs v2+)
        { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    },
    opts = {
        keymap = {
            preset = 'none',
            ['<C-n>'] = { 'select_next', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback' },
            -- Accepts the selected item, or the first one if nothing is
            -- selected (same as cmp.confirm({ select = true }))
            ['<CR>'] = { 'select_and_accept', 'fallback' },
            ['<C-Space>'] = { 'show', 'fallback' },
        },
        completion = {
            -- preselect = false + auto_insert = true mirrors
            -- cmp.PreselectMode.None with cmp.SelectBehavior.Insert
            list = { selection = { preselect = false, auto_insert = true } },
            trigger = {
                -- nvim-cmp showed the menu on trigger chars (e.g. `.`); blink
                -- only triggers on keywords by default
                show_on_trigger_character = true,
                show_on_insert_on_trigger_character = true,
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
            },
            ghost_text = { enabled = true },
            menu = {
                draw = {
                    columns = {
                        { 'kind_icon' },
                        { 'label', 'label_description', gap = 1 },
                        { 'source_name' }, -- [LSP] / [Path] / ... equivalent
                    },
                },
            },
        },
        snippets = { preset = 'luasnip' },
        sources = {
            default = { 'path', 'lsp', 'snippets', 'buffer' },
            providers = {
                buffer = { min_keyword_length = 3, name = 'Buffer' },
                path = { name = 'Path' },
                lsp = { name = 'LSP' },
                snippets = { name = 'Snippet' },
            },
        },
        fuzzy = {
            sorts = { 'exact', 'score', 'sort_text' },
        },
        cmdline = {
            keymap = {
                preset = 'cmdline',
                -- Only accept if the user explicitly selected an item via
                -- <C-n>/<C-p>; otherwise execute the command as normal.
                -- NOTE: in v1, keymap functions must signal fallback by
                -- returning false/nil + listing 'fallback' as the next
                -- command; there is no cmp.fallback() method on v1
                ['<CR>'] = {
                    function(cmp)
                        if cmp.get_selected_item() then
                            return cmp.accept()
                        end
                        return false
                    end,
                    'fallback',
                },
                -- <Space>: only accept if the user explicitly selected an
                -- item via <C-n>/<C-p>, then still type the space so
                -- arguments can be added. Blink applies the accepted
                -- text asynchronously, so the space must be fed from the
                -- accept callback rather than typed first
                ['<Space>'] = {
                    function(cmp)
                        if not cmp.get_selected_item() then
                            return false -- just a normal space
                        end
                        return cmp.accept({
                            callback = function()
                                local space = vim.api.nvim_replace_termcodes(
                                    ' ',
                                    true,
                                    false,
                                    true
                                )
                                vim.api.nvim_feedkeys(space, 'n', false)
                            end,
                        })
                    end,
                    'fallback',
                },
            },
            completion = {
                menu = { auto_show = true },
                -- Nothing selected or inserted until <C-n>/<C-p> is pressed
                list = {
                    selection = { preselect = false, auto_insert = false },
                },
            },
            sources = { 'path', 'cmdline' },
        },
    },
    -- Only complete the command name once it is 3+ chars, so short commands
    -- like `:q` / `:w` execute immediately instead of popping the menu
    sources = {
        providers = {
            cmdline = {
                min_keyword_length = function(ctx)
                    if
                        ctx.mode == 'cmdline'
                        and string.find(ctx.line, ' ') == nil
                    then
                        return 3
                    end
                    return 0
                end,
            },
        },
    },
    opts_extend = { 'sources.default' },
}
