return {
    'dmtrKovalenko/fff.nvim',
    build = function()
        -- downloads a prebuilt binary or falls back to cargo build
        require('fff.download').download_or_build_binary()
    end,
    -- for nixos:
    -- build = "nix run .#release",
    opts = {
        follow_symlinks = true,
        debug = {
            enabled = true,
            show_scores = true,
        },
    },
    config = function(_, opts)
        local fff = require('fff')
        fff.setup(opts)

        -- FFF opens files after closing its picker. Remember the selected
        -- path so Oil can return through a linked directory with `-`.
        local function track_selection()
            local ui = require('fff.picker_ui.picker_ui')
            if ui._keshav_oil_return_wrapped then
                return
            end

            local select = ui.select
            ui.select = function(action)
                local item = ui.state.filtered_items[ui.state.cursor]
                local path = item
                        and require('fff.utils').canonicalize_fff_path(
                            item.relative_path
                        )
                    or nil
                local dir = path and vim.fs.dirname(path) or nil
                local origin = dir and 'oil://' .. dir .. '/' or nil

                select(action)
                if origin then
                    vim.schedule(function()
                        local opened = vim.api.nvim_buf_get_name(0)
                        if opened ~= ''
                            and vim.uv.fs_realpath(opened)
                                == vim.uv.fs_realpath(path)
                        then
                            vim.w.oil_return_dir = origin
                        end
                    end)
                end
            end
            ui._keshav_oil_return_wrapped = true
        end

        for _, method in ipairs({ 'find_files', 'live_grep' }) do
            local open = fff[method]
            fff[method] = function(...)
                track_selection()
                return open(...)
            end
        end
    end,
    lazy = false, -- the plugin lazy-initialises itself
}
