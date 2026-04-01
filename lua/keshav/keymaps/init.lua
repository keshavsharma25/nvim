local n, i, v, t = 'n', 'i', 'v', 't'
local ex_t = { n, i, v }
local n_v = { n, v }
local n_t = { n, t }

local keyset = vim.keymap.set
local default_settings = { noremap = true, silent = true }
local allow_remap = { noremap = false, silent = true }

local M = {}

function M.init()
    -- No higlight
    keyset(n_v, '<leader>n', '<Cmd>noh<CR>', {
        desc = 'Remove [H]ighlights',
        noremap = allow_remap['noremap'],
        silent = allow_remap['silent'],
    })

    -- Go in Normal mode
    keyset(i, 'jk', '<Esc>', default_settings)

    -- Diagnostic keysets

    -- Go to Parent Dir
    keyset(n, '-', '<CMD>:Explore<CR>', { desc = 'Go to Parent Directory' })

    keyset(n, '<leader>cc', function()
        -- Check if the column is currently set to 80
        if vim.wo.colorcolumn == '80' then
            vim.wo.colorcolumn = '0'
            print('ColorColumn Disabled')
        else
            vim.wo.colorcolumn = '80'
            print('ColorColumn Enabled (80)')
        end
    end, { desc = 'Toggle Color Column' })
end

function M.snacks()
    local picker = require('snacks.picker')
    local snacks = require('snacks')

    -- Picker bindings
    keyset(n, '<leader>sh', picker.help, { desc = '[S]earch [H]elp' })
    keyset(n, '<leader>sk', picker.keymaps, { desc = '[S]earch [K]eymaps' })
    keyset(n, '<leader>sf', picker.files, { desc = '[S]earch [F]iles' })
    keyset(n, '<leader>si', picker.git_files, { desc = '[S]earch [I]n Git' })
    keyset(
        n,
        '<leader>ss',
        picker.pickers,
        { desc = '[S]earch [S]elect Picker' }
    )
    keyset(
        n,
        '<leader>sw',
        picker.grep_word,
        { desc = '[S]earch current [W]ord' }
    )
    keyset(n, '<leader>sW', function()
        local word = vim.fn.expand('<cWORD>')
        picker.grep({ search = word })
    end, { desc = '[S]earch current [W]ord(no spaces)' })
    keyset(n, '<leader>sg', picker.grep, { desc = '[S]earch by [G]rep' })
    keyset(
        n,
        '<leader>sd',
        picker.diagnostics,
        { desc = '[S]earch [D]iagnostics' }
    )
    keyset(n, '<leader>sr', picker.resume, { desc = '[S]earch [R]esume' })
    keyset(
        n,
        '<leader>s.',
        picker.recent,
        { desc = '[S]earch Recent Files ("." for repeat)' }
    )
    keyset(
        n,
        '<leader><leader>',
        picker.buffers,
        { desc = '[ ] Find existing buffers' }
    )

    keyset(n, '<leader>/', function()
        picker.lines()
    end, { desc = '[/] Fuzzily search in current buffer' })

    keyset(n, '<leader>s/', function()
        picker.grep_buffers()
    end, { desc = '[S]earch [/] in Open Files' })

    keyset(n, '<leader>sn', function()
        picker.files({ cwd = vim.fn.stdpath('config') })
    end, { desc = '[S]earch [N]eovim files' })

    keyset(n, '<leader>so', function()
        snacks.terminal()
    end, { desc = '[O]Term', noremap = true })
    keyset(
        t,
        '<esc>',
        [[<C-\><C-n>]],
        { desc = 'Exit Terminal', noremap = true }
    )

    -- Rest of the requested Snacks integrations
    keyset(n, '<leader>z', function()
        snacks.zen()
    end, { desc = 'Toggle Zen Mode' })
    keyset(n, '<leader>Z', function()
        snacks.zen.zoom()
    end, { desc = 'Toggle Zoom' })
    keyset(n, '<leader>.', function()
        snacks.scratch()
    end, { desc = 'Toggle Scratch Buffer' })
    keyset(n, '<leader>S', function()
        snacks.scratch.select()
    end, { desc = 'Select Scratch Buffer' })
    keyset(n, '<leader>ns', function()
        snacks.notifier.show_history()
    end, { desc = '[N]otification History: [S]how' })
    keyset(n, '<leader>bd', function()
        snacks.bufdelete()
    end, { desc = 'Delete Buffer' })
    keyset(n, '<leader>cR', function()
        snacks.rename.rename_file()
    end, { desc = 'Rename File' })
    keyset({ 'n', 'v' }, '<leader>gB', function()
        snacks.gitbrowse()
    end, { desc = 'Git Browse' })
    keyset(n, '<leader>sl', function()
        snacks.lazygit()
    end, { desc = 'Lazygit' })
    keyset(n, '<leader>un', function()
        snacks.notifier.hide()
    end, { desc = 'Dismiss All Notifications' })
    keyset(n, '<c-/>', function()
        snacks.terminal()
    end, { desc = 'Toggle Terminal' })
    keyset(n, '<c-_>', function()
        snacks.terminal()
    end, { desc = 'which_key_ignore' })
    keyset({ 'n', 't' }, ']]', function()
        snacks.words.jump(vim.v.count1)
    end, { desc = 'Next Reference' })
    keyset({ 'n', 't' }, '[[', function()
        snacks.words.jump(-vim.v.count1)
    end, { desc = 'Prev Reference' })
end

function M.lsp(e)
    -- LSP Definition, Hover, etc..
    local opts = { buffer = e.buf }
    local picker = require('snacks.picker')

    keyset(n, 'gd', function()
        picker.lsp_definitions()
    end, { desc = '[G]oto [D]efinition', buffer = opts['buffer'] })

    keyset(n, 'gD', function()
        picker.lsp_declarations()
    end, { desc = '[G]oto [D]eclaration', buffer = opts['buffer'] })

    keyset(n, 'gI', function()
        picker.lsp_implementations()
    end, { desc = '[G]oto [I]mplementation', buffer = opts['buffer'] })

    keyset(n, 'gy', function()
        picker.lsp_type_definitions()
    end, { desc = 'Goto T[y]pe Definition', buffer = opts['buffer'] })

    keyset(
        n,
        'gr',
        function()
            picker.lsp_references()
        end,
        { desc = '[G]oto [R]eferences', buffer = opts['buffer'], nowait = true }
    )

    keyset(n, 'gai', function()
        picker.lsp_incoming_calls()
    end, { desc = 'C[a]lls Incoming', buffer = opts['buffer'] })

    keyset(n, 'gao', function()
        picker.lsp_outgoing_calls()
    end, { desc = 'C[a]lls Outgoing', buffer = opts['buffer'] })

    keyset(n, 'K', function()
        vim.lsp.buf.hover()
    end, { desc = 'Hover', buffer = opts['buffer'] })

    keyset('i', '<C-k>', function()
        vim.lsp.buf.signature_help()
    end, opts)

    keyset(n, '<leader>ss', function()
        picker.lsp_symbols()
    end, { desc = 'LSP Symbols', buffer = opts['buffer'] })

    keyset(n, '<leader>sS', function()
        picker.lsp_workspace_symbols()
    end, { desc = 'LSP Workspace Symbols', buffer = opts['buffer'] })

    keyset(n, '<leader>lh', function()
        vim.diagnostic.open_float()
    end, { desc = 'LSP: Show Diagnostic Details', buffer = opts['buffer'] })

    keyset(n, '<leader>lc', function()
        vim.lsp.buf.code_action()
    end, { desc = 'LSP: [C]ode [A]ction', buffer = opts['buffer'] })

    keyset(n, '<leader>lr', function()
        vim.lsp.buf.rename()
    end, { desc = 'LSP: [R]e[n]ame', buffer = opts['buffer'] })

    keyset(n, '[d', function()
        vim.diagnostic.jump({ count = 1 })
    end, { desc = 'Next([) Diagnostics', buffer = opts['buffer'] })

    keyset(n, ']d', function()
        vim.diagnostic.jump({ count = -1 })
    end, { desc = 'Previous(]) Diagnostics', buffer = opts['buffer'] })
end

function M.preventMs()
    keyset(
        n,
        ',m',
        ':keeppatterns %s/\\s\\+$\\|\\r$//e<CR>',
        { silent = default_settings['silent'], desc = 'Remove [M]s' }
    )
end

function M.harpoon()
    local harpoon = require('harpoon')

    keyset(n, '<leader>al', function()
        harpoon:list():add()
    end, { desc = 'Harpoon: [A]dd to [l]ist' })
    keyset(n, '<leader>he', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon: [E]xplore list' })

    keyset(n, '<leader>ha', function()
        harpoon:list():select(1)
    end, { desc = 'Harpoon: [A]dd to 1[a]' })
    keyset(n, '<leader>hb', function()
        harpoon:list():select(2)
    end, { desc = 'Harpoon: [A]dd to 2[b]' })
    keyset(n, '<leader>hc', function()
        harpoon:list():select(3)
    end, { desc = 'Harpoon: [A]dd to 3[c]' })
    keyset(n, '<leader>hd', function()
        harpoon:list():select(4)
    end, { desc = 'Harpoon: add to 4[d]' })
    keyset(n, '<leader>xa', function()
        harpoon:list():replace_at(1)
    end, { desc = 'Harpoon: Replace at 1' })
    keyset(n, '<leader>xb', function()
        harpoon:list():replace_at(2)
    end, { desc = 'Harpoon: Replace at 2' })
    keyset(n, '<leader>xc', function()
        harpoon:list():replace_at(3)
    end, { desc = 'Harpoon: Replace at 3' })
    keyset(n, '<leader>xd', function()
        harpoon:list():replace_at(4)
    end, { desc = 'Harpoon: Replace at 4' })
end

function M.mtoc()
    keyset(
        n,
        '<leader>mt',
        '<CMD>:Mtoc<CR>',
        { desc = 'Markdown: Table of Contents' }
    )
end

function M.markdown()
    keyset(n, 'gk', function()
        vim.cmd('silent! ?^##\\+\\s.*$')
        vim.cmd('nohlsearch')
    end, { desc = 'Go to previous Header' })

    keyset(n, 'gj', function()
        vim.cmd('silent! /^##\\+\\s.*$')
        vim.cmd('nohlsearch')
    end, { desc = 'Go to next Header' })
end

function M.outline()
    keyset(
        n,
        '<leader>ol',
        '<CMD>Outline<CR>',
        { desc = '[O]ut[l]ine: Toggle', noremap = true }
    )
end

function M.cloak_toggle()
    keyset(
        n,
        '<leader><leader>c',
        '<CMD>CloakToggle<CR>',
        { desc = '[C]loakToggle', noremap = true }
    )
end

function M.mini_sessions()
    local write_as_cwd = function()
        local cwd = vim.fn.getcwd()
        local session_name = cwd:gsub('/', '-') -- Replace / with - for filename safety
        require('mini.sessions').write(session_name)
        print('Saved session: ' .. session_name) -- Optional feedback
    end

    keyset(
        'n',
        '<Leader>ws',
        write_as_cwd,
        { desc = '[W]rite [S]ession as cwd' }
    )

    vim.keymap.set('n', '<Leader>wl', function()
        require('mini.sessions').select()
    end, { desc = '(W) [L]oad session' })
end

return M
