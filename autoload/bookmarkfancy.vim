" {{{
let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_bookmarkfancy')
  finish
endif

function! bookmarkfancy#init()
 let g:loaded_bookmarkfancy = 1
endfunction

function! bookmarkfancy#test()
 return "This is bookmarkfancy vim plugin :)"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" }}}
