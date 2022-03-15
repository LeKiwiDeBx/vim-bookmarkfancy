" {{{
let s:save_cpo = &cpo
set cpo&vim

function!
" empty body
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" }}}
