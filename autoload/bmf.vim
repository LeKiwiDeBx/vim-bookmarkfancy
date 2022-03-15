" {{{
let s:save_cpo = &cpo
set cpo&vim

function! bookmarkfancy#test()
 return "TaGaDa :)"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" }}}
