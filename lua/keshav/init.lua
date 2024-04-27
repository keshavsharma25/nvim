require 'keshav.options'
require 'keshav.lazyload'

local K = require('keshav.keymaps')

K.init()
K.preventMs()


local keshavGroup = vim.api.nvim_create_augroup('Keshav', { clear = true }),

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = keshavGroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Clear whitespaces at the end of line',
  group = keshavGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

