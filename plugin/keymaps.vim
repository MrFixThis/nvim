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

" Split rezise
nnoremap <A-,> <C-W>5V
nnoremap <A-.> <C-W>5>
nnoremap <C-,> <C-W><
nnoremap <C-.> <C-W>>
"Need a remaping -- Waiting for Moonlander

" Plugin keymaps
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>ma :MaximizerToggle!<CR>

" Terminal keymaps
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-l> <C-\><C-n><C-w>j
tnoremap <A-j> <C-\><C-n><C-w>k
tnoremap <A-k> <C-\><C-n><C-w>l
