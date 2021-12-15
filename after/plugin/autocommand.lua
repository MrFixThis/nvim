vim.api.nvim_exec([[
  " Highlight yank
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * :silent! lua require("vim.highlight").on_yank({timeout = 40})
  augroup END

  " Java lsp
  augroup jdtls_lsp
    autocmd!
    autocmd FileType java :lua require('mrfixthis.lsp.lsp_config').setup_jdtls()
  augroup end
]], true)
