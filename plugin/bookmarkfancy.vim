" 
let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 BOOKMARKFANCY call bookmarkfancy#test()

let &cpo = s:save_cpo
unlet s:save_cpo


