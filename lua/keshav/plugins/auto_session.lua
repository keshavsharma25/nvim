return {
    {
        'rmagatti/auto-session',
        dependencies = {
            'nvim-telescope/telescope.nvim', -- Only needed if you want to use sesssion lens
        },
        config = function()
            require('auto-session').setup({
                auto_session_suppress_dirs = {
                    '~/',
                    '/',
                    '~/code',
                },
                auto_session_use_git_branch = true,
                auto_save_enabled = true,
                args_allow_single_directory = true,
                bypass_session_save_file_types = { 'netrw' },
            })

            require('keshav.keymaps').autoSession()
        end,
    },
}
