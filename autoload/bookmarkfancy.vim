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
                            / {'bmf_row':g:currentRow,
                            /  'bmf_sign':a:bmfSign, 
                            /  'bmf_color':a:bmfColor,
                            /  'bmf_txt':g:currentText,
                            /  'bmf_timestamp':g:timeStamp
                            / }
                          / }
endfunction

function! bookmarkfancy#design(bmfSign, bmfColor)
    "si la ligne à un bookmark alors on affecte bmfSign et bmfColor sinon rien
    let g:currentRow = line(.)
    if g:bookmarkfancy->has_key(g:currentRow)
        let g:bookmarkfancy["g:currentRow"] ={bmf_sign:a:bmfSign, bmf_color:a:bmfColor}
    endif
endfunction

function! bookmarkfancy#remove()
    let g:currentRow = line(.)
    if g:bookmarkfancy->has_key(g:currentRow)
        g:bookmarkfancy->remove(g:currentRow)
        return v:true
    endif
endfunction

function! bookmarkfancy#update()
    return
endfunction 

function! bookmarkfancy#sort(bmfOrder)
    if a:bmfOrder ==# 'ASC'
        for key in keys(g:bookmarkfancy)->sort()
            echom g:bookmarkfancy[key]
        endfor
    elseif a:bmfOrder ==# 'DESC'
        for key in keys(g:bookmarkfancy)->sort()->reverse()
            echom g:bookmarkfancy[key]
        endfor
    endif
endfunction   
    
let &cpo = s:save_cpo
unlet s:save_cpo

" }}}
