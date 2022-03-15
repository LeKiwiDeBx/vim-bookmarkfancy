" 
let s:save_cpo = &cpo
set cpo&vim

command! BookMarkFancyTest call bookmarkfancy#test()

let &cpo = s:save_cpo
unlet s:save_cpo


