require('ibl').setup({
    indent = {
        char = '▏',
        tab_char = '▏',
        highlight = 'NonText',
        smart_indent_cap = true,
    },

    whitespace = {
        remove_blankline_trail = true,
    },

    -- VS Code does NOT show scope guides by default
    scope = {
        enabled = false,
    },

    exclude = {
        filetypes = {
            'help', 'dashboard', 'neo-tree', 'Trouble', 'trouble',
            'lazy', 'mason', 'notify', 'toggleterm', 'lazyterm',
            'packer', 'checkhealth', 'man', 'gitcommit',
            'TelescopePrompt', 'TelescopeResults', 'lspinfo',
            'alpha', 'starter', '',
        },
        buftypes = {
            'terminal', 'nofile', 'quickfix', 'prompt',
        },
    },
})

vim.api.nvim_create_autocmd("TextChanged", {
  callback = function()
    if vim.bo.modifiable then
      vim.cmd("silent! normal! ==")
    end
  end,
})

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
