-- =====================================================
-- Refined Auto Diagnostic Float
-- =====================================================

-- 1. Modern Sign Definitions
-- Note: Added a trailing space to icons for better visual spacing in the sign column
local signs = {
    Error = " ", 
    Warn  = " ", 
    Hint  = "󰌵 ", 
    Info  = " ",
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {
        text = icon,
        texthl = hl,
        numhl = hl,
    })
end

vim.diagnostic.config({
    signs = true,
    underline = true,
    virtual_text = false, -- Keeps UI clean
    severity_sort = true,
    -- Ensure float settings are consistent
    float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

vim.o.updatetime = 250 -- Slightly higher to prevent "flicker" while typing/moving
local diag_auto_enabled = true

-- 2. Optimized Float Logic
local function open_diagnostic_float()
    local _, winid = vim.diagnostic.open_float(nil, {
        focusable = false, -- PREVENTS cursor from entering the window automatically
        close_events = { "CursorMoved", "CursorMovedI", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        scope = "line",
    })
    return winid
end

-- 3. Autocommands
local diag_group = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })

vim.api.nvim_create_autocmd("CursorHold", {
    group = diag_group,
    callback = function()
        if diag_auto_enabled and not vim.api.nvim_get_mode().mode:find("i") then
            open_diagnostic_float()
        end
    end,
})

-- =====================================================
-- Keymaps
-- =====================================================

-- Toggle Auto
vim.keymap.set("n", "<leader>dt", function()
    diag_auto_enabled = not diag_auto_enabled
    local status = diag_auto_enabled and "ON" or "OFF"
    vim.notify("Diagnostic Auto-Float: " .. status, vim.log.levels.INFO)
end, { desc = "Toggle diagnostic auto float" })

-- Manual Open (This one IS focusable so you can jump in with 'gl' to scroll)
vim.keymap.set("n", "gl", function()
    vim.diagnostic.open_float({ border = "rounded", focusable = true })
end, { desc = "Open diagnostic float (focusable)" })

-- Modern Jump API (Neovim 0.10+)
vim.keymap.set("n", "<M-j>", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "<M-k>", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })
