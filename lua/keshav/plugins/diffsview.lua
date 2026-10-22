return {
    'sindrets/diffview.nvim',
    opts = {
        view = {
            default = {
                layout = 'diff2_horizontal',
            },
        },
        file_panel = {
            win_config = function()
                local view = require('diffview.lib').get_current_view()
                local layout = view and view.cur_layout
                local base = layout and layout.a
                local win = base and base.id
                if not win or not vim.api.nvim_win_is_valid(win) then
                    -- During initial layout creation, use the pivot window.
                    win = 0
                end

                return {
                    type = 'split',
                    position = 'bottom',
                    relative = 'win',
                    win = win,
                    height = 14,
                }
            end,
        },
        hooks = {
            view_post_layout = function(view)
                local layout = view.cur_layout
                if not layout or layout.name ~= 'diff2_horizontal' then
                    return
                end

                -- B is the new version; move its window, not its buffer, so
                -- Diffview keeps the correct revision and editing semantics.
                vim.api.nvim_win_call(layout.b.id, function()
                    vim.cmd('wincmd H')
                end)
            end,
        },
    },
}
