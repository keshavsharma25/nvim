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
    keyset(n_v, '<leader>h', '<Cmd>noh<CR>', {
        desc = 'Remove [H]ighlights',
        noremap = allow_remap['noremap'],
        silent = allow_remap['silent'],
    })

    -- Go in Normal mode
    keyset(i, 'jk', '<Esc>', default_settings)

    -- Diagnostic keysets

    -- Go to Parent Dir
    keyset(n, '-', '<CMD>:Explore<CR>', { desc = 'Go to Parent Directory' })
end

function M.telescope()
    local builtin = require('telescope.builtin')

    keyset(n, '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    keyset(n, '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    keyset(n, '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    keyset(n, '<leader>si', builtin.git_files, { desc = '[S]earch [I]n Git' })
    keyset(
        n,
        '<leader>ss',
        builtin.builtin,
        { desc = '[S]earch [S]elect Telescope' }
    )
    keyset(
        n,
        '<leader>sw',
        builtin.grep_string,
        { desc = '[S]earch current [W]ord' }
    )
    keyset(n, '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    keyset(
        n,
        '<leader>sd',
        builtin.diagnostics,
        { desc = '[S]earch [D]iagnostics' }
    )
    keyset(n, '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    keyset(
        n,
        '<leader>s.',
        builtin.oldfiles,
        { desc = '[S]earch Recent Files ("." for repeat)' }
    )
    keyset(
        n,
        '<leader><leader>',
        builtin.buffers,
        { desc = '[ ] Find existing buffers' }
    )

    keyset(n, '<leader>/', function()
        builtin.current_buffer_fuzzy_find(
            require('telescope.themes').get_dropdown({
                winblend = 10,
                previewer = false,
            })
        )
    end, { desc = '[/] Fuzzily search in current buffer' })

    keyset(n, '<leader>s/', function()
        builtin.live_grep({
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
        })
    end, { desc = '[S]earch [/] in Open Files' })

    keyset(n, '<leader>sn', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
    end, { desc = '[S]earch [N]eovim files' })

    keyset(n, '<leader>sW', function()
        local word = vim.fn.expand('<cWORD>')
        builtin.grep_string({ search = word })
    end, { desc = '[S]earch current [W]ord(no spaces)' })
end

function M.telescope_browse()
    -- keyset to open Telescope File Browser
    keyset(
        n,
        '<space>sb',
        ':Telescope file_browser path=%:p:h select_buffer=true<CR>',
        { noremap = true, desc = '[S]earch in [B]rowser' }
    )
end

function M.lsp(e)
    -- LSP Definition, Hover, etc..
    local opts = { buffer = e.buf }

    keyset(n, 'gd', function()
        vim.lsp.buf.definition()
    end, { desc = '[G]oto [D]efinition', buffer = opts['buffer'] })

    keyset(n, 'gD', function()
        vim.lsp.buf.declaration()
    end, { desc = '[G]oto [D]eclaration', buffer = opts['buffer'] })

    keyset(n, 'gi', function()
        vim.lsp.buf.implementation()
    end, { desc = '[G]oto [I]mplementation', buffer = opts['buffer'] })

    keyset(n, 'gr', function()
        vim.lsp.buf.references()
    end, { desc = '[G]oto [R]eferences', buffer = opts['buffer'] })

    keyset(n, 'K', function()
        vim.lsp.buf.hover()
    end, { desc = 'Hover', buffer = opts['buffer'] })

    keyset('i', '<C-k>', function()
        vim.lsp.buf.signature_help()
    end, opts)

    keyset(n, '<leader>lw', function()
        vim.lsp.buf.workspace_symbol()
    end, {
        desc = 'LSP: [W]orkspace [S]ymbol',
        buffer = opts['buffer'],
    })

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
        vim.diagnostic.goto_next()
    end, { desc = 'Next([) Diagnostics', buffer = opts['buffer'] })

    keyset(n, ']d', function()
        vim.diagnostic.goto_prev()
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

function M.autoSession()
    local sesh_lens = require('auto-session.session-lens')
    keyset(
        n,
        '<leader>sl',
        sesh_lens.search_session,
        { desc = 'Session Lens', noremap = true }
    )
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

function M.toggle_term()
    keyset(
        n,
        '<leader>oo',
        '<CMD>ToggleTerm direction=float<CR>',
        { desc = '[O]pen [O]Term', noremap = true }
    )

    keyset(
        t,
        '<esc>',
        [[<C-\><C-n>]],
        { desc = 'Exit Terminal', noremap = true }
    )
end

return M
