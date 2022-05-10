let g:loaded_bookmarkfancy = 0

function! s:init()
 if g:loaded_bookmarkfancy ==# 0
    call bookmarkfancy#init()
 endif
endfunction

"Commands {{{
function! BookMarkFancyTest()
  echo bookmarkfancy#test()
endfunction

command! BookMarkFancyTest call BookMarkFancyTest()
"}}}

" Mapping {{{
execute "nnoremap <silent> <Plug> BookMarkFancyTest : bmt <CR>"

"}}}

" Init {{{
if has('vim_starting')
  autocmd VimEnter * call s:init()
else
  call s:init()
endif
