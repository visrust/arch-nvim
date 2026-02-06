vim.defer_fn(function()
    require('user.autopairs.autopairs')
    -- require('autopairs.autopair_rule') -- already required in autopairs
end, 300)

vim.defer_fn(function()
    require('user.keymaps.general')
end, 300)

vim.defer_fn(function()
    require('autocmds.diagnostic')
end, 300)
