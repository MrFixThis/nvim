" "format beautifully
" autocmd BufWritePre *.go :silent! lua require("go.format").gofmt()
" "goimport baby
" autocmd BufWritePre (InsertLeave?) <buffer> lua vim.lsp.buf.formatting_sync(nil,500)
