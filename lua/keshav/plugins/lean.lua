return {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

    ---@type lean.Config
    opts = {
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
    },
}
