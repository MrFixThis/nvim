-- Yanking settings
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  callback = function()
    vim.highlight.on_yank({ timeout = 40 })
  end,
})
