
-------------------------------------------------
-- 1. Global Diagnostic UI Settings
-------------------------------------------------
local diag_icons = {
    Error = " ",
    Warn  = " ",
    Hint  = " ",
    Info  = " ",
}

for type, icon in pairs(diag_icons) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- THE TRICK: Set the background but explicitly disable the line
local function set_diag_highlights()
    -- bg = The color of the "block"
    -- underline = false (removes the straight line)
    -- undercurl = false (removes the wavy line)
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { bg = "#4b252c", underline = false, undercurl = false })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn",  { bg = "#423824", underline = false, undercurl = false })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",  { bg = "#243a3a", underline = false, undercurl = false })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo",  { bg = "#242e3a", underline = false, undercurl = false })
end

set_diag_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_diag_highlights,
})

vim.diagnostic.config({
    -- We keep this 'true' so Neovim applies the highlight groups to the text
    underline = true, 
    virtual_text = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        format = function(d)
            local icon = diag_icons[vim.diagnostic.severity[d.severity]:gsub("^%l", string.upper)] or ""
            return string.format("%s %s", icon, d.message)
        end,
    },
})

-------------------------------------------------
-- 2. State & Auto-commands (Unchanged)
-------------------------------------------------
local diag_enabled = true
local group = vim.api.nvim_create_augroup("SmartDiagFloat", { clear = true })

local function open_smart_float()
    local _, winid = vim.diagnostic.open_float(nil, {
        focusable = false,
        scope = "line",
        relative = "editor",
        row = 1,
        col = vim.o.columns - 2,
        anchor = "NE",
        width = math.floor(vim.o.columns * 0.45),
    })
    
    if winid then
        vim.wo[winid].winblend = 5
        vim.wo[winid].wrap = true
    end
end

local function setup_autocmds()
    vim.api.nvim_clear_autocmds({ group = group })
    if diag_enabled then
        vim.api.nvim_create_autocmd("CursorHold", {
            group = group,
            callback = open_smart_float,
        })
    end
end

-------------------------------------------------
-- 3. Toggle & Keymaps (Unchanged)
-------------------------------------------------
_G.toggle_diag_panel = function()
    diag_enabled = not diag_enabled
    setup_autocmds()
    if not diag_enabled then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local conf = vim.api.nvim_win_get_config(win)
            if conf.relative ~= "" and conf.zindex == 45 then 
                vim.api.nvim_win_close(win, true)
            end
        end
    end
    print("Diag panel: " .. (diag_enabled and "ON" or "OFF"))
end

vim.keymap.set("n", "<leader>tp", _G.toggle_diag_panel, { desc = "Toggle diag panel" })
vim.keymap.set("n", "tt", open_smart_float, { desc = "Show line diagnostics" })

vim.opt.updatetime = 200
setup_autocmds()
