local M = {}

function M.create_autocmd(auto_groups)
  --Auto group creation
  for gp, configs in pairs(auto_groups) do
    --Group
    local group = vim.api.nvim_create_augroup(gp, configs.opts)

    --Autocmd group creation
    for _, autocmd in pairs(configs.autocmd) do
      vim.api.nvim_create_autocmd(
        autocmd.event, {
          pattern = autocmd.pattern,
          command = autocmd.command,    --Only one is taken
          callback = autocmd.callback,  --^
          group = group
      })
    end
  end
end

return M
