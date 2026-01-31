-- lua/config/alpha.lua
local ok, alpha = pcall(require, "alpha")
if not ok then return end

local dashboard = require("alpha.themes.dashboard")
local ascii = require("ascii")

-- ======================================================
-- HEADER
-- ======================================================
dashboard.section.header.val = ascii.art.text.neovim.sharp
dashboard.section.header.opts.hl = "AlphaHeader"


-- ======================================================
-- BUTTON HELPERS (clean look)
-- ======================================================
local function btn(key, label, cmd)
  return dashboard.button(key, " " .. key .. "  " .. label, cmd)
end


-- ======================================================
-- BUTTON GROUPS (IDE style)
-- ======================================================
dashboard.section.buttons.val = {

  -- FILES
  btn("f", "Find file",       ":FzfLua files<CR>"),
  btn("r", "Recent files",    ":FzfLua oldfiles<CR>"),
  btn("g", "Live grep",       ":FzfLua live_grep<CR>"),
  btn("y", "Yazi manager",    ":Yazi<CR>"),
  btn("o", "Oil explorer",    ":Oil<CR>"),

  { type = "padding", val = 1 },

  -- PROJECT
  btn("l", "LazyGit",         ":LazyGit<CR>"),
  btn("b", "Build / Overseer",":OverseerRun<CR>"),
  btn("d", "Debug (DAP UI)",  ":lua require'dapui'.toggle()<CR>"),
  btn("t", "Terminal",        ":ToggleTerm<CR>"),

  { type = "padding", val = 1 },

  -- SYSTEM
  btn("s", "Sessions",        ":SessionSearch<CR>"),
  btn("p", "Plugins (Lazy)",  ":Lazy<CR>"),
  btn("c", "Config",          ":e $MYVIMRC<CR>"),
  btn("q", "Quit",            ":qa<CR>"),
}


-- ======================================================
-- FOOTER (stats)
-- ======================================================
local function footer()
  local stats = require("lazy").stats()

  local datetime = os.date(" %d-%m-%Y   %H:%M")
  local version = vim.version()

  return string.format(
    "%s   ⚡ %d plugins in %.2fms   󰕈 v%d.%d.%d",
    datetime,
    stats.count,
    stats.startuptime,
    version.major,
    version.minor,
    version.patch
  )
end

dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = "AlphaFooter"


-- ======================================================
-- LAYOUT (centered IDE style spacing)
-- ======================================================
dashboard.config.layout = {
  { type = "padding", val = 2 },
  dashboard.section.header,
  { type = "padding", val = 2 },
  dashboard.section.buttons,
  { type = "padding", val = 2 },
  dashboard.section.footer,
}


-- ======================================================
-- HIGHLIGHTS (works great with gruvbox/tokyonight/nightfox)
-- ======================================================
vim.cmd([[
  highlight AlphaHeader   guifg=#7aa2f7
  highlight AlphaButtons  guifg=#c0caf5
  highlight AlphaShortcut guifg=#ff9e64
  highlight AlphaFooter   guifg=#565f89
]])


-- ======================================================
-- SETUP
-- ======================================================
alpha.setup(dashboard.config)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "alpha",
  callback = function()
    vim.opt_local.foldenable = false
  end,
})
