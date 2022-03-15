" 
let s:save_cpo = &cpo
set cpo&vim

function! BookMarkFancyTest()
  return bookmarkfancy#test()
endfunction

command! BookMarkFancyTest call BookMarkFancyTest()

let &cpo = s:save_cpo
unlet s:save_cpo


