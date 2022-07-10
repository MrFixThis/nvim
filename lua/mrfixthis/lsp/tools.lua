local M = {}
local diagnostic = vim.diagnostic

M.diagnostics_qfixlist = function ()
  local diagnostics_list = diagnostic.get()
  local qfx_diagnostics = diagnostic.toqflist(diagnostics_list)
  if next(qfx_diagnostics) == nil then
    vim.api.nvim_command("silent! cclose")
    return
  end
  diagnostic.setqflist(qfx_diagnostics)
end

return M
