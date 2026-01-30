require('gruvbox').setup({
    terminal_colors = true,
    bold = true,
    italic = {
        strings = true,
        emphasis = true,
        comments = true,
        folds = true,
    },
    contrast = 'hard',
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "gruvbox",
  callback = function()
    -- Directly link columns to Normal (Fastest method)
    local groups = { "SignColumn"}
    for _, group in ipairs(groups) do
      vim.api.nvim_set_hl(0, group, { link = "Normal" })
    end

    -- Clean up Diagnostic Signs
    -- We link them to their base highlight groups so they inherit the color 
    -- but stay transparent/consistent with your background.
    vim.api.nvim_set_hl(0, "DiagnosticSignError", { link = "DiagnosticError" })
    -- Note: Most modern themes already do this, but if Gruvbox is being 
    -- stubborn with backgrounds, we force it here:
    vim.api.nvim_set_hl(0, "DiagnosticSignWarn",  { link = "DiagnosticWarn" })
    vim.api.nvim_set_hl(0, "DiagnosticSignInfo",  { link = "DiagnosticInfo" })
    vim.api.nvim_set_hl(0, "DiagnosticSignHint",  { link = "DiagnosticHint" })
  end,
})
