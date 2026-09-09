return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
        picker = {
            enabled = true,
            sources = {
                gh_issue = {},
                gh_pr = {},
                gh_diff = {
                    group = true,
                    confirm = function(picker, item, action)
                        if not item then
                            return
                        end
                        if not item.diff then
                            return require('snacks.picker.actions').jump(
                                picker,
                                item,
                                action
                            )
                        end
                        -- Close background pickers (e.g. gh_pr left open
                        -- underneath gh_diff) first, then this one last,
                        -- so `resume` sees gh_diff as newest.
                        for _, p in ipairs(Snacks.picker.get() or {}) do
                            if p ~= picker and not p.closed then
                                p:close()
                            end
                        end
                        picker:close()
                        vim.schedule(function()
                            local cmd = action and action.cmd
                            if cmd == 'split' then
                                vim.cmd('new')
                            elseif cmd == 'vsplit' then
                                vim.cmd('vnew')
                            elseif cmd == 'tab' then
                                vim.cmd('tabnew')
                            else
                                vim.cmd('enew')
                            end
                            local buf = vim.api.nvim_get_current_buf()
                            local win = vim.api.nvim_get_current_win()
                            local pr = item.gh_item and item.gh_item.number
                                or nil
                            local file = item.file or 'diff'
                            local safe_file = file:gsub('/', '__')
                            local name = pr
                                    and ('PR#' .. tostring(pr) .. ' Diff: ' .. safe_file)
                                or ('Diff: ' .. safe_file)
                            pcall(vim.api.nvim_buf_set_name, buf, name)
                            vim.bo[buf].buftype = 'nofile'
                            vim.bo[buf].bufhidden = 'wipe'
                            vim.bo[buf].swapfile = false
                            local ns =
                                vim.api.nvim_create_namespace('snacks_gh_diff')
                            local ok, Diff =
                                pcall(require, 'snacks.picker.util.diff')
                            if ok then
                                Diff.render(buf, ns, item.diff, {
                                    annotations = item.annotations,
                                })
                            else
                                vim.bo[buf].modifiable = true
                                vim.api.nvim_buf_set_lines(
                                    buf,
                                    0,
                                    -1,
                                    false,
                                    vim.split(item.diff, '\n')
                                )
                            end
                            vim.bo[buf].modifiable = false
                            vim.bo[buf].modified = false
                            vim.wo[win].wrap = true
                            vim.wo[win].breakindent = true
                            vim.wo[win].linebreak = true
                            vim.wo[win].showbreak = ''
                            pcall(vim.api.nvim_win_set_cursor, win, { 1, 0 })
                            vim.keymap.set('n', 'q', '<cmd>bd<CR>', {
                                buffer = buf,
                                noremap = true,
                                silent = true,
                                desc = 'Close diff buffer',
                            })
                        end)
                    end,
                    win = {
                        list = {
                            keys = {
                                o = 'jump',
                            },
                        },
                    },
                },
            },
        },
        zen = { enabled = true },
        scratch = { enabled = true },
        notifier = { enabled = true },
        bufdelete = { enabled = true },
        rename = { enabled = true },
        gitbrowse = { enabled = true },
        lazygit = { enabled = true },
        terminal = { enabled = true },
        words = { enabled = true },
        gh = {
            enabled = true,
        },
    },
    config = function(_, opts)
        require('snacks').setup(opts)
        require('keshav.keymaps').snacks()
    end,
}
