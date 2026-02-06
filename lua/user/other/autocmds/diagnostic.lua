vim.api.nvim_create_user_command("DiagYankWhole", function()
  local diags = vim.diagnostic.get(0)
  if vim.tbl_isempty(diags) then
    print("No diagnostics in buffer")
    return
  end

  local lines = {}
  for _, d in ipairs(diags) do
    table.insert(lines, string.format(
      "%s (%d:%d): %s",
      d.source or "LSP",
      d.lnum + 1,
      d.col + 1,
      d.message
    ))
  end

  vim.fn.setreg('"', table.concat(lines, "\n"))
  print("Buffer diagnostics yanked")
end, {})


vim.api.nvim_create_user_command("DiagYankWorkspace", function()
  local lines = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      for _, d in ipairs(vim.diagnostic.get(buf)) do
        table.insert(lines, string.format(
          "%s:%d:%d [%s] %s",
          name ~= "" and name or "[No Name]",
          d.lnum + 1,
          d.col + 1,
          d.source or "LSP",
          d.message
        ))
      end
    end
  end

  if #lines == 0 then
    print("No diagnostics in workspace")
    return
  end

  vim.fn.setreg('"', table.concat(lines, "\n"))
  print("Workspace diagnostics yanked")
end, {})
