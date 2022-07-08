" Execute this file
function! s:save_and_exec() abort
  if &filetype == 'vim'
    silent! write
    source %
  elseif &filetype == 'lua'
    silent! write
    luafile %
  endif
  return
endfunction

nnoremap <leader>x :call <SID>save_and_exec()<CR>
