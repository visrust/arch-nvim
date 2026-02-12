local resession = require("resession")

resession.setup({
    autosave = {
        enabled = true,
        interval = 60,
        notify = false,
    },
    options = {
        "binary",
        "bufhidden",
        "buflisted",
        "cmdheight",
        "diff",
        "filetype",
        "modifiable",
        "previewwindow",
        "readonly",
        "scrollbind",
        "winfixheight",
        "winfixwidth",
    },
    extensions = {
        quickfix = {},
    },
    buf_filter = function(bufnr)
        local buftype = vim.bo[bufnr].buftype
        return buftype ~= "help" and buftype ~= "nofile"
    end,
})

-- Helper: session name = current folder name
local function session_name()
    local cwd = vim.fn.getcwd()
    local home = vim.loop.os_homedir()

    -- Don't create sessions for $HOME
    if cwd == home then
        return nil
    end

    return vim.fn.fnamemodify(cwd, ":t")
end

-- Auto load on start
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local name = session_name()
        if not name then return end

        if vim.tbl_contains(resession.list(), name) then
            resession.load(name, { notify = false })
        end
    end,
})

-- Auto save on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        local name = session_name()
        if not name then return end
        resession.save(name, { notify = false })
    end,
})

-- Manual save
vim.keymap.set("n", "<leader>ss", function()
    local name = session_name()
    if not name then
        vim.notify("Not inside a project folder", vim.log.levels.WARN)
        return
    end
    resession.save(name)
    vim.notify("Saved session: " .. name)
end, { desc = "Session: Save" })

-- Manual load
vim.keymap.set("n", "<leader>sl", function()
    local name = session_name()
    if not name then
        vim.notify("Not inside a project folder", vim.log.levels.WARN)
        return
    end
    resession.load(name)
    vim.notify("Loaded session: " .. name)
end, { desc = "Session: Load" })

-- Optional: session picker
vim.keymap.set("n", "<leader>sf", function()
    local sessions = resession.list()
    if #sessions == 0 then
        vim.notify("No sessions available", vim.log.levels.WARN)
        return
    end

    vim.ui.select(sessions, { prompt = "Select session:" }, function(choice)
        if choice then
            resession.load(choice)
        end
    end)
end, { desc = "Session: Find" })
