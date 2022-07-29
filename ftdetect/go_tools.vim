"format beautifully, baby -> "gofumpt + goimport
autocmd BufWritePre *.go :silent! lua require("go.format").goimport()
