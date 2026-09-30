return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        watch_for_changes = true,
        view_options = {
            show_hidden = true,
        },
    },
    config = function(_, opts)
        local files = require('oil.adapters.files')
        local normalize_url = files.normalize_url

        -- Keep the path through a symlink so `-` returns to its directory.
        files.normalize_url = function(url, callback)
            local scheme, path = require('oil.util').parse_url(url)
            if scheme ~= 'oil://' or not path then
                return normalize_url(url, callback)
            end

            local absolute = vim.fs.normalize(vim.fn.fnamemodify(path, ':p'))
            normalize_url(url, function(resolved)
                if vim.startswith(resolved, scheme) then
                    local dir = absolute:sub(-1) == '/'
                            and absolute
                        or absolute .. '/'
                    callback(scheme .. dir)
                else
                    callback(vim.fn.fnamemodify(absolute, ':.'))
                end
            end)
        end

        require('oil').setup(opts)

        vim.api.nvim_create_autocmd('BufLeave', {
            desc = 'Remember the Oil directory used to open a file',
            callback = function(event)
                local name = vim.api.nvim_buf_get_name(event.buf)
                vim.w.oil_return_dir = vim.startswith(name, 'oil://')
                        and name
                    or nil
            end,
        })
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
}
