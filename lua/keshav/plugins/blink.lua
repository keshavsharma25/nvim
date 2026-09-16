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
            ['<CR>'] = { 'select_and_accept', 'fallback' },
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
                ['<C-space>'] = { 'select_and_accept' },
                ['<CR>'] = {
                    function(cmp)
                        if cmp.get_selected_item() then
                            return cmp.accept()
                        end
                        return false
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
    opts_extend = { 'sources.default' },
}
