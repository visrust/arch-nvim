-------------------------------------------------
-- Icons
-------------------------------------------------
local diag_icons = {
    Error = '',
    Warn  = '',
    Hint  = '',
    Info  = '',
}

for type, icon in pairs(diag_icons) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
end


-------------------------------------------------
-- State
-------------------------------------------------
local enabled = true
local float_win = nil
local float_buf = nil
local group = vim.api.nvim_create_augroup('SmartDiagFloat', { clear = true })


-------------------------------------------------
-- Helpers
-------------------------------------------------
local function close_float()
    if float_win and vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_win_close(float_win, true)
    end
    float_win, float_buf = nil, nil
end


local function build_lines(buf)
    local diags = vim.diagnostic.get(
        0,
        { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 }
    )

    if #diags == 0 then return nil end

    local lines = {}
    local highlights = {}

    for i, d in ipairs(diags) do
        local icon, hl

        if d.severity == vim.diagnostic.severity.ERROR then
            icon = diag_icons.Error
            hl = 'DiagnosticError'
        elseif d.severity == vim.diagnostic.severity.WARN then
            icon = diag_icons.Warn
            hl = 'DiagnosticWarn'
        elseif d.severity == vim.diagnostic.severity.HINT then
            icon = diag_icons.Hint
            hl = 'DiagnosticHint'
        else
            icon = diag_icons.Info
            hl = 'DiagnosticInfo'
        end

        local text = icon .. ' ' .. d.message:gsub('\n', ' ')
        table.insert(lines, text)
        table.insert(highlights, { line = i - 1, hl = hl })
    end

    return lines, highlights
end

-------------------------------------------------
-- Main float
-------------------------------------------------
local function show_panel()
    close_float()

    float_buf = vim.api.nvim_create_buf(false, true)

    local lines, highlights = build_lines(float_buf)
    if not lines then return end

    vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)

    for _, h in ipairs(highlights) do
        vim.api.nvim_buf_add_highlight(float_buf, -1, h.hl, h.line, 0, -1)
    end

    -------------------------------------------------
    -- Dynamic size calculation (smart)
    -------------------------------------------------
    local padding = 2

    -- find longest line
    local max_len = 0
    for _, l in ipairs(lines) do
        max_len = math.max(max_len, vim.fn.strdisplaywidth(l))
    end

    -- screen limits (never exceed these)
    local max_width  = math.floor(vim.o.columns * 0.45) -- at most 45% screen
    local max_height = math.floor(vim.o.lines * 0.35) -- at most 35% screen

    -- final width
    local width      = math.min(max_len + padding, max_width)

    -- calculate wrapped height
    local height     = 0
    for _, l in ipairs(lines) do
        local w = vim.fn.strdisplaywidth(l)
        height = height + math.max(1, math.ceil(w / width))
    end

    height = math.min(height + 1, max_height)

    local errors, warns, hints, info = 0, 0, 0, 0

    for _, d in ipairs(vim.diagnostic.get(0)) do
        if d.severity == 1 then
            errors = errors + 1
        elseif d.severity == 2 then
            warns = warns + 1
        elseif d.severity == 3 then
            hints = hints + 1
        else
            info = info + 1
        end
    end

    local title   = string.format(
        ' Diagnostics (Err: %d , Wa: %d, Hin: %d, Inf: %d) ',
        errors, warns, hints, info
    )
    float_win     = vim.api.nvim_open_win(float_buf, false, {
        relative = 'editor',
        anchor = 'NE',
        row = 1,
        col = vim.o.columns - 2,

        width = width,
        height = height,

        border = 'rounded',
        style = 'minimal',

        title = title,
        title_pos = 'left', -- left | center | right
    })

    -- window options
    local wo      = vim.wo[float_win]
    wo.wrap       = true
    wo.linebreak  = true
    wo.winblend   = 0
    wo.scrolloff  = 2
    wo.cursorline = false
    wo.scroll     = 1

    -- make scrollable
    vim.keymap.set('n', '<C-d>', '<C-d>', { buffer = float_buf })
    vim.keymap.set('n', '<C-u>', '<C-u>', { buffer = float_buf })
end


-------------------------------------------------
-- Toggle system
-------------------------------------------------
local function enable_auto()
    vim.api.nvim_create_autocmd({ 'CursorHold' }, {
        group = group,
        callback = show_panel,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter' }, {
        group = group,
        callback = close_float,
    })
end


local function disable_auto()
    vim.api.nvim_clear_autocmds({ group = group })
    close_float()
end


function _G.toggle_diag_panel()
    enabled = not enabled
    if enabled then
        enable_auto()
        print('Diag panel: ON')
    else
        disable_auto()
        print('Diag panel: OFF')
    end
end

-------------------------------------------------
-- Keymaps
-------------------------------------------------
vim.keymap.set('n', '<leader>tp', toggle_diag_panel, { desc = 'Toggle diag panel' })
vim.keymap.set('n', 'tt', show_panel, { desc = 'Show line diagnostics' })


-------------------------------------------------
-- Faster hover feel
-------------------------------------------------
vim.opt.updatetime = 150

enable_auto()
