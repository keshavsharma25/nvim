local n, i, v, t = 'n', 'i', 'v', 't'
local ex_t = { n, i, v }
local n_v = { n, v }

local keymap = vim.keymap.set
local default_settings = { noremap = true, silent = true }
local allow_remap = { noremap = false, silent = true }

local M = {}

function M.init()
    -- No higlight
    keymap(n_v, '<leader>h', '<Cmd>noh<CR>', {
        desc = 'Remove [H]ighlights',
        noremap = allow_remap['noremap'],
        silent = allow_remap['silent'],
    })

    -- Go in Normal mode
    keymap(i, 'jk', '<Esc>', default_settings)

    -- Diagnostic keymaps
    keymap(
        n,
        '[d',
        vim.diagnostic.goto_prev,
        { desc = 'Go to previous [D]iagnostic message' }
    )
    keymap(
        n,
        ']d',
        vim.diagnostic.goto_next,
        { desc = 'Go to next [D]iagnostic message' }
    )
    keymap(
        n,
        '<leader>e',
        vim.diagnostic.open_float,
        { desc = 'Show diagnostic [E]rror messages' }
    )
    keymap(
        n,
        '<leader>q',
        vim.diagnostic.setloclist,
        { desc = 'Open diagnostic [Q]uickfix list' }
    )

    -- Go to Parent Dir
    keymap(n, '-', '<CMD>:E<CR>', { desc = 'Go to Parent Directory' })
end

function M.telescope()
    local builtin = require('telescope.builtin')

    keymap(n, '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    keymap(n, '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    keymap(n, '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    keymap(n, '<leader>si', builtin.git_files, { desc = '[S]earch [I]n Git' })
    keymap(
        n,
        '<leader>ss',
        builtin.builtin,
        { desc = '[S]earch [S]elect Telescope' }
    )
    keymap(
        n,
        '<leader>sw',
        builtin.grep_string,
        { desc = '[S]earch current [W]ord' }
    )
    keymap(n, '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    keymap(
        n,
        '<leader>sd',
        builtin.diagnostics,
        { desc = '[S]earch [D]iagnostics' }
    )
    keymap(n, '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    keymap(
        n,
        '<leader>s.',
        builtin.oldfiles,
        { desc = '[S]earch Recent Files ("." for repeat)' }
    )
    keymap(
        n,
        '<leader><leader>',
        builtin.buffers,
        { desc = '[ ] Find existing buffers' }
    )

    keymap(n, '<leader>/', function()
        builtin.current_buffer_fuzzy_find(
            require('telescope.themes').get_dropdown({
                winblend = 10,
                previewer = false,
            })
        )
    end, { desc = '[/] Fuzzily search in current buffer' })

    keymap(n, '<leader>s/', function()
        builtin.live_grep({
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
        })
    end, { desc = '[S]earch [/] in Open Files' })

    keymap(n, '<leader>sn', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
    end, { desc = '[S]earch [N]eovim files' })

    keymap(n, '<leader>sW', function()
        local word = vim.fn.expand('<cWORD>')
        builtin.grep_string({ search = word })
    end, { desc = '[S]earch current [W]ord(no spaces)' })
end

function M.telescope_browse()
    -- Keymap to open Telescope File Browser
    keymap(
        n,
        '<space>sb',
        ':Telescope file_browser path=%:p:h select_buffer=true<CR>',
        { noremap = true, desc = '[S]earch in [B]rowser' }
    )
end

function M.lsp(e)
    -- LSP Definition, Hover, etc..
    local opts = { buffer = e.buf }

    keymap(n, 'gd', function()
        vim.lsp.buf.definition()
    end, { desc = '[G]oto [D]efinition', buffer = opts['buffer'] })

    keymap(n, 'gD', function()
        vim.lsp.buf.declaration()
    end, { desc = '[G]oto [D]eclaration', buffer = opts['buffer'] })

    keymap(n, 'gr', function()
        vim.lsp.buf.references()
    end, { desc = '[G]oto [R]eferences', buffer = opts['buffer'] })

    keymap(n, 'K', function()
        vim.lsp.buf.hover()
    end, { desc = 'Hover', buffer = opts['buffer'] })

    keymap(n, '<leader>dw', function()
        vim.lsp.buf.workspace_symbol()
    end, {
        desc = '[D]iagnostics: [W]orkspace [S]ymbol',
        buffer = opts['buffer'],
    })

    keymap(n, '<leader>dh', function()
        vim.diagnostic.open_float()
    end, { desc = 'Hover', buffer = opts['buffer'] })

    keymap(n, '<leader>ca', function()
        vim.lsp.buf.code_action()
    end, { desc = '[D]iagnostics: [C]ode [A]ction', buffer = opts['buffer'] })

    keymap(n, '<leader>rn', function()
        vim.lsp.buf.rename()
    end, { desc = '[D]iagnostics: [R]e[n]ame', buffer = opts['buffer'] })

    vim.keymap.set('i', '<C-h>', function()
        vim.lsp.buf.signature_help()
    end, opts)

    keymap(n, '[d', function()
        vim.diagnostic.goto_next()
    end, { desc = 'Next([) Diagnostics', buffer = opts['buffer'] })

    keymap(n, ']d', function()
        vim.diagnostic.goto_prev()
    end, { desc = 'Previous(]) Diagnostics', buffer = opts['buffer'] })
end

function M.preventMs()
    keymap(
        n,
        ',m',
        ':keeppatterns %s/\\s\\+$\\|\\r$//e<CR>',
        { silent = default_settings['silent'], desc = 'Remove [M]s' }
    )
end

function M.trouble()
    keymap('n', '<leader>tt', function()
        require('trouble').toggle()
    end, { desc = '[T]oggle [T]rouble' })
end

function M.harpoon()
    local harpoon = require('harpoon')

    vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
    end, { desc = 'Harpoon: Add to list' })
    vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon: Show list' })

    vim.keymap.set('n', '<C-w>', function()
        harpoon:list():select(1)
    end, { desc = 'Harpoon: Add to 1' })
    vim.keymap.set('n', '<C-a>', function()
        harpoon:list():select(2)
    end, { desc = 'Harpoon: Add to 2' })
    vim.keymap.set('n', '<C-z>', function()
        harpoon:list():select(3)
    end, { desc = 'Harpoon: Add to 3' })
    vim.keymap.set('n', '<C-x>', function()
        harpoon:list():select(4)
    end, { desc = 'Harpoon: add to 4' })
    vim.keymap.set('n', '<leader><C-w>', function()
        harpoon:list():replace_at(1)
    end, { desc = 'Harpoon: Replace at 1' })
    vim.keymap.set('n', '<leader><C-a>', function()
        harpoon:list():replace_at(2)
    end, { desc = 'Harpoon: Replace at 2' })
    vim.keymap.set('n', '<leader><C-z>', function()
        harpoon:list():replace_at(3)
    end, { desc = 'Harpoon: Replace at 3' })
    vim.keymap.set('n', '<leader><C-x>', function()
        harpoon:list():replace_at(4)
    end, { desc = 'Harpoon: Replace at 4' })
end

return M
