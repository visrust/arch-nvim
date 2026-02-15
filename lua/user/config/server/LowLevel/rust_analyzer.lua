local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

lspconfig.rust_analyzer.setup({
  cmd = { "rust-analyzer" },

  root_dir = function(fname)
    return util.root_pattern("Cargo.toml")(fname)
  end,

  single_file_support = false,

  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = { command = "clippy" },
      procMacro = { enable = true },
    },
  },
})
