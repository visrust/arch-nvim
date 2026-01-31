vim.defer_fn(function()
    require('autopairs.autopairs')
    -- require('autopairs.autopair_rule') -- already required in autopairs
end, 200)

vim.defer_fn(function()
    require('keymaps.general')
end, 100)

vim.defer_fn(function ()
    require('themes.gruvbox')
end, 200)

vim.defer_fn(function()
    require('global_functions.resize_arrow')
    -- require("global_functions.close_under_cursor")
    require('global_functions.show_hide_divides')
end, 100)

vim.defer_fn(function()
    require('autocmds.diagnostic')
end, 200)
