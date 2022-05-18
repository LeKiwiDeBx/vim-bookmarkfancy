" {{{
let s:save_cpo = &cpo
set cpo&vim

"if exists('g:loaded_bookmarkfancy')
" finish
"endif

function! bookmarkfancy#init()
 let g:loaded_bookmarkfancy = 1
endfunction

function! bookmarkfancy#test()
 return "This is bookmarkfancy vim plugin :)"
endfunction

function! bookmarkfancy#create(bmfSign, bmfColor)
    let idx = 0
    let g:max_lenght = 45
    let g:currentRow = line(.)
    let g:timeStamp = localtime()
    let g:currentText = currentRow->getline()->strcharpart(idx, g:max_lenght)
    let g:bookmarkfancy = {g:currentRow:
                            / {'bmf_sign':a:bmfSign, 
                            /  'bmf_color':a:bmfColor,
                            /  'bmf_txt':g:currentText,
                            /  'bmf_timestamp':g:timeStamp
                            / }
                          / }
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" }}}
