-- Cokeline.nvim Configuration with Live Diagnostics + Unsaved Changes

local get_hex = require('cokeline.hlgroups').get_hl_attr

-- Helper function to get diagnostic counts
local function get_diagnostics(buffer)
    local diagnostics = vim.diagnostic.get(buffer.number)
    local counts = { errors = 0, warnings = 0, hints = 0, info = 0 }
    
    for _, diagnostic in ipairs(diagnostics) do
        if diagnostic.severity == vim.diagnostic.severity.ERROR then
            counts.errors = counts.errors + 1
        elseif diagnostic.severity == vim.diagnostic.severity.WARN then
            counts.warnings = counts.warnings + 1
        elseif diagnostic.severity == vim.diagnostic.severity.HINT then
            counts.hints = counts.hints + 1
        elseif diagnostic.severity == vim.diagnostic.severity.INFO then
            counts.info = counts.info + 1
        end
    end
    
    return counts
end

-- Helper function to check if buffer is modified (unsaved)
local function is_modified(buffer)
    return vim.bo[buffer.number].modified
end

require('cokeline').setup({
    default_hl = {
        fg = function(buffer)
            return buffer.is_focused and get_hex('Normal', 'fg') or get_hex('Comment', 'fg')
        end,
        bg = function(buffer)
            return buffer.is_focused and get_hex('ColorColumn', 'bg') or get_hex('Normal', 'bg')
        end,
    },

    components = {
        -- Space before buffer
        {
            text = ' ',
        },
        
        -- Buffer index/number
        {
            text = function(buffer)
                return buffer.index .. ':'
            end,
            fg = function(buffer)
                return buffer.is_focused and get_hex('Special', 'fg') or get_hex('Comment', 'fg')
            end,
            bold = function(buffer)
                return buffer.is_focused
            end,
        },
        
        -- Space
        {
            text = ' ',
        },
        
        -- Devicon (file type icon)
        {
            text = function(buffer)
                return buffer.devicon.icon
            end,
            fg = function(buffer)
                return buffer.devicon.color
            end,
        },
        
        -- Space
        {
            text = ' ',
        },
        
        -- Filename
        {
            text = function(buffer)
                return buffer.unique_prefix .. buffer.filename
            end,
            fg = function(buffer)
                return buffer.is_focused and get_hex('Normal', 'fg') or get_hex('Comment', 'fg')
            end,
            bold = function(buffer)
                return buffer.is_focused
            end,
            italic = function(buffer)
                return not buffer.is_focused
            end,
        },
        
        -- Modified indicator (unsaved changes)
        {
            text = function(buffer)
                return is_modified(buffer) and ' ●' or ''
            end,
            fg = function(buffer)
                return is_modified(buffer) and get_hex('DiagnosticError', 'fg') or nil
            end,
            bold = true,
        },
        
        -- Diagnostics - Errors
        {
            text = function(buffer)
                local diag = get_diagnostics(buffer)
                return diag.errors > 0 and ' ' .. diag.errors or ''
            end,
            fg = function(buffer)
                local diag = get_diagnostics(buffer)
                return diag.errors > 0 and get_hex('DiagnosticError', 'fg') or nil
            end,
        },
        
        -- Diagnostics - Warnings
        {
            text = function(buffer)
                local diag = get_diagnostics(buffer)
                return diag.warnings > 0 and ' ' .. diag.warnings or ''
            end,
            fg = function(buffer)
                local diag = get_diagnostics(buffer)
                return diag.warnings > 0 and get_hex('DiagnosticWarn', 'fg') or nil
            end,
        },
        
        -- Diagnostics - Hints
        {
            text = function(buffer)
                local diag = get_diagnostics(buffer)
                return diag.hints > 0 and ' ' .. diag.hints or ''
            end,
            fg = function(buffer)
                local diag = get_diagnostics(buffer)
                return diag.hints > 0 and get_hex('DiagnosticHint', 'fg') or nil
            end,
        },
        
        -- Diagnostics - Info
        {
            text = function(buffer)
                local diag = get_diagnostics(buffer)
                return diag.info > 0 and ' ' .. diag.info or ''
            end,
            fg = function(buffer)
                local diag = get_diagnostics(buffer)
                return diag.info > 0 and get_hex('DiagnosticInfo', 'fg') or nil
            end,
        },
        
        -- Close button
        {
            text = function(buffer)
                return buffer.is_focused and ' ✖ ' or ' '
            end,
            fg = function(buffer)
                return buffer.is_focused and get_hex('DiagnosticError', 'fg') or get_hex('Comment', 'fg')
            end,
            on_click = function(_, _, _, _, buffer)
                buffer:delete()
            end,
        },
        
        -- Separator
        --    ▉   ▊
        {
            text = '█',
            fg = function(buffer)
                return buffer.is_focused and get_hex('Normal', 'fg') or get_hex('Comment', 'fg')
            end,
        },
    },
})

-- Optional: Update diagnostics on save and LSP attach
vim.api.nvim_create_autocmd({ 'DiagnosticChanged', 'BufWritePost' }, {
    callback = function()
        vim.cmd('redrawtabline')
    end,
})

-- Optional: Keymaps for buffer navigation
vim.keymap.set('n', '<S-Tab>', '<Plug>(cokeline-focus-prev)', { silent = true, desc = 'Previous buffer' })
vim.keymap.set('n', '<Tab>', '<Plug>(cokeline-focus-next)', { silent = true, desc = 'Next buffer' })

-- Move buffer left/right
vim.keymap.set('n', '<A-,>', '<Plug>(cokeline-switch-prev)', { silent = true })
vim.keymap.set('n', '<A-.>', '<Plug>(cokeline-switch-next)', { silent = true })
