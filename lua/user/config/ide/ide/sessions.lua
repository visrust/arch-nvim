-- ============================================================================
-- RESESSION - ACTUALLY WORKS
-- ============================================================================

vim.opt.sessionoptions = {
    "buffers",       -- Buffer list (your open files)
    "curdir",        -- Current directory (project root)
    "tabpages",      -- Tab pages
    "winsize",       -- Window sizes
    "winpos",        -- Window position (optional, for GUI)
}

local resession = require('resession')

resession.setup({
    autosave = {
        enabled = false,
        interval = 60,
        notify = false,
    },
    extensions = {
        quickfix = {},
    },
})

-- Kill junk before save
vim.api.nvim_create_autocmd('User', {
    pattern = 'ResessionSavePre',
    callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) then
                local name = vim.api.nvim_buf_get_name(buf)
                if name:match('^term://') then
                    pcall(vim.api.nvim_buf_delete, buf, { force = true })
                end
            end
        end
    end,
})

-- Get all sessions
local function get_sessions()
    return resession.list()
end

-- CREATE: <leader>sc
vim.keymap.set('n', '<leader>sc', function()
    local default = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    vim.ui.input({ prompt = 'Session: ', default = default }, function(name)
        if name and name ~= '' then
            resession.save(name)
            print('✓ ' .. name)
        end
    end)
end, { desc = 'create session' })

-- SAVE: <leader>ss
vim.keymap.set('n', '<leader>ss', function()
    local current = resession.get_current()
    if current then
        resession.save(current, { notify = false })
        print('✓ ' .. current)
    else
        print('No session. Use <leader>sc')
    end
end, { desc = 'save current session' })

-- LOAD: <leader>sf
vim.keymap.set('n', '<leader>sf', function()
    local sessions = get_sessions()
    if #sessions == 0 then
        print('No sessions')
        return
    end
    require('fzf-lua').fzf_exec(sessions, {
        prompt = 'Load> ',
        actions = {
            ['default'] = function(s)
                if s[1] then resession.load(s[1]) end
            end,
        }
    })
end, { desc = 'session fuzzy' })

-- DELETE: <leader>sd
vim.keymap.set('n', '<leader>sd', function()
    local sessions = get_sessions()
    if #sessions == 0 then return end
    require('fzf-lua').fzf_exec(sessions, {
        prompt = 'Delete> ',
        actions = {
            ['default'] = function(s)
                if s[1] then
                    resession.delete(s[1])
                    print('✓ Deleted ' .. s[1])
                end
            end,
        }
    })
end, { desc = 'session delete' })

-- INFO: <leader>si
vim.keymap.set('n', '<leader>si', function()
    local current = resession.get_current()
    print(current and ('Current: ' .. current) or 'No session')
    print('Total: ' .. #get_sessions())
end, { desc = 'session info' })
