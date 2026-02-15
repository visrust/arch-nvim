local icons = { Error = ' ', Warn = ' ', Hint = '󰌶 ', Info = ' ' }
--------------------------------------------------------------------------------
-- DYNAMIC DIAGNOSTIC ECHO - Full Error Display with Cycling
--------------------------------------------------------------------------------

-- State management
local echo_timer = vim.loop.new_timer()
local current_diag_index = 1

-- Helper: Get all diagnostics for current line (not just under cursor)
local function get_line_diagnostics()
    if not vim.api.nvim_buf_is_valid(0) then return {} end
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    return vim.diagnostic.get(0, { lnum = line })
end

-- Helper: Format diagnostic message (no truncation)
local function format_message(msg)
    msg = msg:gsub('\r\n', ' ')
    msg = msg:gsub('\n', ' ')
    msg = msg:gsub('\r', ' ')
    msg = msg:gsub('\t', ' ')
    msg = msg:gsub('%s+', ' ')
    return vim.trim(msg)
end

-- Helper: Calculate required cmdheight for message
local function calculate_cmdheight(display_text)
    local screen_width = vim.o.columns
    local usable_width = math.max(screen_width - 20, 50)
    local text_width = vim.fn.strdisplaywidth(display_text)
    local required_lines = math.ceil(text_width / usable_width)
    return math.min(math.max(required_lines, 1), 10)
end

-- Helper: Count diagnostics by severity
local function count_diagnostics(diags)
    local counts = { Error = 0, Warn = 0, Info = 0, Hint = 0 }
    local severity_map = { [1] = 'Error', [2] = 'Warn', [3] = 'Info', [4] = 'Hint' }
    for _, d in ipairs(diags) do
        local sev = severity_map[d.severity]
        if sev then counts[sev] = counts[sev] + 1 end
    end
    return counts
end

-- Helper: Format summary (e.g., "+ ×2 Warn ×3 Hint")
local function format_summary(counts, exclude_severity)
    local parts = {}
    local order = { 'Error', 'Warn', 'Info', 'Hint' }
    for _, sev in ipairs(order) do
        if counts[sev] > 0 and sev ~= exclude_severity then
            table.insert(parts, string.format('×%d %s', counts[sev], sev))
        end
    end
    if #parts > 0 then
        return ' + ' .. table.concat(parts, ' ')
    end
    return ''
end

-- Main echo function
local function dynamic_echo()
    if not vim.api.nvim_buf_is_valid(0) then return end

    local diags = get_line_diagnostics()

    -- Reset if no diagnostics
    if #diags == 0 then
        current_diag_index = 1
        if vim.o.cmdheight ~= 1 then
            vim.o.cmdheight = 1
        end
        vim.api.nvim_echo({}, false, {})
        return
    end

    -- Sort by severity (Error > Warn > Info > Hint)
    table.sort(diags, function(a, b) return a.severity < b.severity end)

    -- Ensure index is valid
    if current_diag_index > #diags then
        current_diag_index = 1
    end

    local d = diags[current_diag_index]
    local severity_map = { [1] = 'Error', [2] = 'Warn', [3] = 'Info', [4] = 'Hint' }
    local sev_name = severity_map[d.severity]
    local hl = 'Diagnostic' .. sev_name
    local icon = icons[sev_name]

    -- Format the full message
    local msg = format_message(d.message)
    
    -- Build display: icon + message
    local display = icon .. ' ' .. msg

    -- Add related diagnostics of same severity
    local same_severity = vim.tbl_filter(function(diag)
        return diag.severity == d.severity
    end, diags)

    if #same_severity > 1 then
        for i, related in ipairs(same_severity) do
            if i > 1 then
                local related_msg = format_message(related.message)
                display = display .. ' | ' .. related_msg
            end
        end
    end

    -- Count other diagnostics
    local counts = count_diagnostics(diags)
    local summary = format_summary(counts, sev_name)
    
    if summary ~= '' then
        display = display .. summary
    end

    -- Calculate and set cmdheight
    local required_height = calculate_cmdheight(display)
    if vim.o.cmdheight ~= required_height then
        vim.o.cmdheight = required_height
    end

    -- Display message
    pcall(function()
        vim.api.nvim_echo({ { display, hl } }, false, {})
    end)
end

local safe_echo = vim.schedule_wrap(dynamic_echo)

-- Trigger on cursor movement
vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    callback = function()
        current_diag_index = 1
        echo_timer:stop()
        echo_timer:start(20, 0, safe_echo)
    end,
})

-- Reset cmdheight when leaving buffer
vim.api.nvim_create_autocmd('BufLeave', {
    callback = function()
        vim.schedule(function()
            if vim.o.cmdheight ~= 1 then
                vim.o.cmdheight = 1
            end
            current_diag_index = 1
        end)
    end,
})

-- Diagnostic configuration
vim.opt.shortmess:append('AFWc')

vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.Error,
            [vim.diagnostic.severity.WARN]  = icons.Warn,
            [vim.diagnostic.severity.INFO]  = icons.Info,
            [vim.diagnostic.severity.HINT]  = icons.Hint,
        },
        linehl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticLineError',
            [vim.diagnostic.severity.WARN]  = 'DiagnosticLineWarn',
            [vim.diagnostic.severity.INFO]  = 'DiagnosticLineInfo',
            [vim.diagnostic.severity.HINT]  = 'DiagnosticLineHint',
        },
    },
    severity_sort = true,
    update_in_insert = false,
})

-- Highlight settings
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineUnnecessary", { 
    fg = "NONE",
    bg = "NONE",
    sp = "NONE",
    undercurl = false,
    underline = false,
})

--------------------------------------------------------------------------------
-- KEYMAPS
--------------------------------------------------------------------------------

-- Cycle through diagnostics on current line
vim.keymap.set('n', ',d', function()
    local diags = get_line_diagnostics()
    if #diags == 0 then
        vim.notify("No diagnostics on current line", vim.log.levels.INFO)
        return
    end

    current_diag_index = current_diag_index + 1
    if current_diag_index > #diags then
        current_diag_index = 1
    end

    dynamic_echo()
end, { desc = "Cycle through line diagnostics" })

-- Jump to next/prev diagnostic
vim.keymap.set('n', '<M-j>', function() 
    vim.diagnostic.jump({count = 1})
    current_diag_index = 1
end, {desc = "Next diagnostic"})

vim.keymap.set('n', '<M-k>', function() 
    vim.diagnostic.jump({count = -1})
    current_diag_index = 1
end, {desc = "Prev diagnostic"})

-- Open diagnostic float (catches cursor)
vim.keymap.set('n', 'gl', function()
    vim.diagnostic.open_float({
        border = 'rounded',
        focusable = true,
        focus = true,
        source = 'always',
        severity_sort = true,
        max_width = 100,
        max_height = 30,
        wrap = true,
    })
end, { desc = "Open diagnostic float" })
