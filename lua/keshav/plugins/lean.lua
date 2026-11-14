return {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

    init = function()
        ---@type lean.Config
        vim.g.lean_config = {
            mappings = true,
            infoview = {
                autoopen = true,
                orientation = 'auto',
                width = 50,
                height = 12,
            },
        }
    end,

    config = function()
        require('keshav.keymaps').lean()

        vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'FileType' }, {
            group = vim.api.nvim_create_augroup('LeanInfoviewVisibility', {
                clear = true,
            }),
            desc = 'Show the Lean infoview only while working in Lean',
            callback = function()
                local win = vim.api.nvim_get_current_win()
                vim.schedule(function()
                    if
                        not vim.api.nvim_win_is_valid(win)
                        or vim.api.nvim_get_current_win() ~= win
                    then
                        return
                    end

                    local config = vim.api.nvim_win_get_config(win)
                    if
                        config.relative ~= ''
                        or config.external
                        or vim.bo.buftype ~= ''
                    then
                        return
                    end

                    local infoview = package.loaded['lean.infoview']
                    if not infoview then
                        return
                    end

                    local ft = vim.bo.filetype
                    if ft == 'lean' then
                        infoview.open()
                    elseif ft ~= 'leaninfo' and ft ~= 'leanstderr' then
                        infoview.close()
                    end
                end)
            end,
        })
    end,
}
