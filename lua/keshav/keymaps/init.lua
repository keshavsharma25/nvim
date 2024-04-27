local n, i, v, t = 'n', 'i', 'v', 't'
local ex_t = { n, i, v }
local n_v = { n, v }

local keymap = vim.keymap.set
local default_settings = { noremap = true, silent = true }
local allow_remap = { noremap = false, silent = true }

local M = {}

function M.init()
	keymap(n_v, '<leader>h', '<Cmd>noh<CR>', allow_remap)
	keymap(i, 'jk', '<Esc>', default_settings)
end

return M
