return {
    'Vigemus/iron.nvim',
    enabled = true,
    config = function()
        local iron = require('iron.core')

        iron.setup({
            config = {
                -- Whether a repl should be discarded or not
                scratch_repl = true,
                -- Your repl definitions come here
                repl_definition = {
                    sh = {
                        -- Can be a table or a function that
                        -- returns a table (see below)
                        command = { 'zsh' },
                    },
                    python = {
                        command = { 'python3' }, -- or { "ipython", "--no-autoindent" }
                        format = require('iron.fts.common').bracketed_paste_python,
                        block_dividers = { '# %%', '#%%' },
                    },
                },
                -- How the repl window will be displayed
                -- See below for more information
                repl_open_cmd = require('iron.view').right(40),
            },
            -- Iron doesn't set keymaps by default anymore.
            -- You can set them here or manually add keymaps to the functions in iron.core
            keymaps = {
                toggle_repl = '<space>ii',
                send_motion = '<space>ic',
                visual_send = '<space>ic',
                send_file = '<space>if',
                send_line = '<space>il',
                send_paragraph = '<space>ip',
                send_until_cursor = '<space>iu',
                send_mark = '<space>im',
                mark_motion = '<space>imc',
                mark_visual = '<space>imc',
                remove_mark = '<space>imd',
                cr = '<space>i<cr>',
                interrupt = '<space>i<space>',
                exit = '<space>iq',
                clear = '<space>ik',
            },
            -- If the highlight is on, you can change how it looks
            -- For the available options, check nvim_set_hl
            highlight = {
                italic = true,
            },
            ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
        })
    end,
}
