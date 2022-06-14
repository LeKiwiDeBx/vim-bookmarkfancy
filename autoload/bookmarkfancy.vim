" {{{
let s:save_cpo = &cpo
set cpo&vim

"if exists('g:loaded_bookmarkfancy')
" finish
"endif

function! bookmarkfancy#init()
    let g:loaded_bookmarkfancy = 1
    let g:bookmarkfancy_list = []
endfunction

function! bookmarkfancy#test()
    return "This is bookmarkfancy vim plugin :)"
endfunction

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#toggle()
"
" crée ou enléve le bmf
" return : rien
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#toggle()
    let g:currentRow = line(".")
    if g:bookmarkfancy->has_key(g:currentRow)
        g:bookmarkfancy->delete(g:currentRow)
    else
        call bookmarkfancy#create(g:bmfflavors['normal']['bmf_sign'], g:bmfflavors['normal']['bmf_color'])
    endif
endfunction    

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#create(bmfSign, bmfColor)
"
" crée le bmf dans le dict.
" bmfSign :  un caractère symbolique
" bmfColor : une couleur symbolique
" return :   rien
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#create(bmfSignId, bmf_sign = '', bmf_color = '') "{{{
    let idx = 0
    let g:max_lenght = 45
    let g:currentRow = line(".")
    let bmfSign = a:bmf_sign->empty() ? g:bmfflavors["normal"]["bmf_sign"] :  a:bmf_sign
    let bmfColor = a:bmf_color->empty() ? g:bmfflavors["normal"]["bmf_color"] : a:bmf_color 
    " echom "/nbmfColor du create : " .. bmfColor
    let g:currentText = g:currentRow->getline()->strcharpart(idx, g:max_lenght)
    let g:currentBuffer = bufnr()
    let g:currentFile = expand("%:p")    
    let g:currentStatus = 1 "status = 0: disabled, 1: enabled"
    let g:timeStamp = localtime()
    let g:bookmarkfancy = {g:currentRow: 
                \              {'bmf_row':g:currentRow,
                \               'bmf_sign_id': a:bmfSignId,
                \               'bmf_sign':bmfSign, 
                \               'bmf_color':bmfColor,
                \               'bmf_txt':g:currentText,
                \               'bmf_buffer':g:currentBuffer,
                \               'bmf_file':g:currentFile,
                \               'bmf_status':g:currentStatus,
                \               'bmf_timestamp':g:timeStamp
                \              }
                \         }
    return g:bookmarkfancy
endfunction
" }}}

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#design(bmfSign, bmfColor)
"
" change en une passe le visuel symbole/couleur du bmf  
" bmfSign :     un caractère symbolique
" bmfColor :    une couleur du symbole
" return :      rien 
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#design(bmfSign, bmfColor) "{{{
    "si la ligne à un bookmark alors on affecte bmfSign et bmfColor sinon rien
    let g:currentRow = line(".")
    if g:bookmarkfancy->has_key(g:currentRow)
        let g:bookmarkfancy["g:currentRow"] ={bmf_sign:a:bmfSign, bmf_color:a:bmfColor}
    endif
endfunction
" }}}

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#flavor(bmfFlavor) 
"
" change en une passe le visuel avec une saveur prédeterminée  bmf  
" bmfFlavor : combo symbole/couleur ie: g:bmfflavors["normal"] normal est une flavor
" return : rien 
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#flavor(bmfFlavor) "{{{
    "si la ligne à un bookmark alors on affecte bmfSign et bmfColor sinon rien
    let g:currentRow = line(".")
    if g:bookmarkfancy->has_key(g:currentRow)
        let g:bookmarkfancy["g:currentRow"] ={bmf_sign:a:bmfFlavor["bmf_sign"], bmf_color:a:bmfFlavor["bmf_color"]}
    endif
endfunction
" }}}

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#remove()
"
" enlève la ligne en cours du dict. 
" param: aucun
" return : vrai si il y'a bmf 
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#remove(line_number = 0) "{{{
    let g:currentRow = a:line_number ==# 0 ? line(".") : a:line_number
    let l:idx = 0
    for bookmarkfancy_dict in g:bookmarkfancy_list
        if values(bookmarkfancy_dict)[0]['bmf_row'] ==# g:currentRow
            "echom keys(bookmarkfancy_dict)[0]
            call remove(g:bookmarkfancy_list, l:idx)
            return  values(bookmarkfancy_dict)[0]['bmf_sign_id']
            " TODO ecrire sign_unplace dans bmf_sign.vim
            " return bmf_sign_id : values(bookmarkfancy_dict)[0]['bmf_sign_id']
            " pour pouvoir sign_unplace
        endif
        let l:idx += 1
    endfor 
    return v:false
endfunction
" }}}

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#read(0 by default)
"
" lit une ligne particuliere ou par defaut la ligne en cours
" param: ligne à lire
" return: le bmf
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#read(bmfLineNumber = 0) "{{{
    let g:currentRow = a:bmfLineNumber ==# 0 ? line(".")  : a:bmfLineNumber 
    if !g:bookmarkfancy_list->empty()
        for dic_row in g:bookmarkfancy_list 
            if !dic_row->empty()
                if values(dic_row)[0]['bmf_row'] ==# g:currentRow 
                    return values(dic_row)[0]
                endif    
            endif
        endfor
    endif
    return v:false
endfunction
" }}}

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#view(how)
"
" affiche dans quick la liste des bookmarks
" param: how quel type affichage complet(tous les fichiers), partiel, actif/inactif
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#view(how = 'ALL')
    "h: setqflist() à partir bookmarkfancy_list m.a.j. par rapport sign add/delete
endfunction

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#update()
"
" mise a jour du bmf 
" param: aucun
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#update() "{{{
    return 1
endfunction 
" }}}

function CompareRow(row1, row2) 
    "echo a:row1[0]
    return a:row1[0]['bmf_row'] == a:row2[0]['bmf_row']? 0:a:row1[0]['bmf_row'] >a:row2[0]['bmf_row']? 1:-1
endfunction

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#sort(bmfOrder) 
" dict2list avec perte de la clé dictionnaire (keys) 
" bmfOrder : ordre du tri 'ASC' ou 'DESC'
" return : une liste de liste (nested list)
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#sort(bmfOrder = 'ASC') "{{{
    let g:dic_row_list = []
    let g:bmfList = []
    let g:bmfDic = []
    for dic_row in g:bookmarkfancy_list    
        let g:dic_row_list = g:dic_row_list->add(values(dic_row)) 
    endfor
    let g:bmfDic = g:dic_row_list->sort("CompareRow")
    for row in a:bmfOrder ==# 'ASC'? g:bmfDic : g:bmfDic->reverse() 
        let g:bmfList = g:bmfList->add(row[0])
    endfor
    echom g:bmfList
    bookmarkfancy#init
    return g:bmfList
endfunction   
" }}}  

let &cpo = s:save_cpo
unlet s:save_cpo

" }}}
