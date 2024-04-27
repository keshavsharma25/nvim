return {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  config = function() require('keshav.keymaps').telescope_browse() end,
  opt = {
    extensions = {
      file_browser = {
        theme = 'ivy',
        -- disables netrw and use telescope-file-browser in its place
        hijack_netrw = true,
        mappings = {
          ['i'] = {
            -- your custom insert mode mappings
          },
          ['n'] = {
            -- your custom normal mode mappings
          },
        },
      },
    },
  },
}

