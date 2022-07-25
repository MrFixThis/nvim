local M = {}

--Autocmd factory
function M.create_autocmd(aucmd_content)
  for gp_name, content in pairs(aucmd_content) do
    --Group
    local group = vim.api.nvim_create_augroup(gp_name, content.opts)

    --Autocmd creation
    for _, autocmd in pairs(content.autocmd) do
      vim.api.nvim_create_autocmd(autocmd.event,
      {
          pattern = autocmd.pattern,
          command = autocmd.command,   --Non-nil is taken
          callback = autocmd.callback, --^
          group = group
      })
    end
  end
end

return M
