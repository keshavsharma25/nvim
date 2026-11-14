return {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

    init = function()
        ---@type lean.Config
        vim.g.lean_config = {
            -- <LocalLeader> is Space k; keep Lean's standard buffer mappings.
            mappings = true,
            infoview = {
                autoopen = true,
                -- Beside the proof on wide screens, below it on narrow screens.
                orientation = 'auto',
                width = 50,
                height = 12,
            },
            -- LSP, Unicode abbreviations, widgets and progress bars use defaults.
            -- Let lean.nvim manage leanls; do not also enable it through Mason.
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
                -- Wait until buffer/window transitions have finished.
                vim.schedule(function()
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
