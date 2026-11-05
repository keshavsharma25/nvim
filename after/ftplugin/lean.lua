-- Inspect goals without leaving the proof or opening the full infoview.
vim.keymap.set('n', '<LocalLeader>g', '<cmd>LeanGoal<CR>', {
    buffer = true,
    silent = true,
    desc = 'Lean: tactic goal at cursor',
})
vim.keymap.set('n', '<LocalLeader>t', '<cmd>LeanTermGoal<CR>', {
    buffer = true,
    silent = true,
    desc = 'Lean: expected term type at cursor',
})
