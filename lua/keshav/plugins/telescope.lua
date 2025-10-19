return {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable('make') == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')

        local custom_actions = {}

        function custom_actions.fzf_multi_select(prompt_bufnr)
            local function get_table_size(t)
                local count = 0
                for _ in pairs(t) do
                    count = count + 1
                end
                return count
            end

            local picker = action_state.get_current_picker(prompt_bufnr)
            local num_selections = get_table_size(picker:get_multi_selection())

            if num_selections > 1 then
                actions.send_selected_to_qflist(prompt_bufnr)
                actions.open_qflist(prompt_bufnr)
            else
                actions.select_default(prompt_bufnr)
            end
        end

        telescope.setup({
            extensions = {
                ['ui-select'] = { require('telescope.themes').get_dropdown() },
            },
            defaults = {
                mappings = {
                    n = {
                        ['q'] = require('telescope.actions').close,
                        ['<CR>'] = custom_actions.fzf_multi_select,
                    },
                },
            },
        })

        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        require('keshav.keymaps').telescope()
    end,
}
