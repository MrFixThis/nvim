" Windows and tabs navigation
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>

nnoremap <Right> gt
nnoremap <Left> gT

" Coping
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

" Buffer utils
nnoremap <localleader>w :w<CR>
nnoremap <localleader>v :q<CR>
nnoremap <localleader>W :w!<CR>
nnoremap <localleader>V :q!<CR>
nnoremap <localleader>= <C-W>=
nnoremap <A-,> <C-W>5V
nnoremap <A-.> <C-W>5>
nnoremap <C-,> <C-W><
nnoremap <C-.> <C-W>>

" Plugin keymaps
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>ma :MaximizerToggle!<CR>
nnoremap <leader>ne :lua vim.diagnostic.setqflist()<CR>

" Terminal keymaps
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-l> <C-\><C-n><C-w>j
tnoremap <C-j> <C-\><C-n><C-w>k
tnoremap <C-k> <C-\><C-n><C-w>l
