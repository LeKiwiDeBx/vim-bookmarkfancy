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
function! bookmarkfancy#create(bmfSignId, bmfSign = '', bmfColor = '') "{{{
    let idx = 0
    let g:max_lenght = 45
    let g:currentRow = line(".")
    let g:timeStamp = localtime()
    let g:currentText = g:currentRow->getline()->strcharpart(idx, g:max_lenght)
    let g:bookmarkfancy = { g:currentRow: 
                \              {'bmf_row':g:currentRow,
                \               'bmf_sign_id': a:bmfSignId,
                \               'bmf_sign':a:bmfSign, 
                \               'bmf_color':a:bmfColor,
                \               'bmf_txt':g:currentText,
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
function! bookmarkfancy#remove() "{{{
    let g:currentRow = line(".")
    if g:bookmarkfancy->has_key(g:currentRow)
        g:bookmarkfancy->remove(g:currentRow)
        return v:true
    endif
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
    if a:bmfLineNumber ==# 0
        let g:currentRow = line(".")
    else
        let g:currentRow = a:bmfLineNumber
    endif
    if g:bookmarkfancy->has_key(g:currentRow)
        return g:bookmarkfancy[g:currentRow]
    else
        return "" 
    endif
endfunction
" }}}

" ~~~~~~~~~~~~~~~~~~~~~0~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#update()
"
" mise a jour du bmf 
" param: aucun
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#update() "{{{
    return
endfunction 
" }}}

function CompareRow(row1, row2) 
    "echo a:row1[0]
    return a:row1[0]['bmf_row'] == a:row2[0]['bmf_row']? 0:a:row1[0]['bmf_row'] >a:row2[0]['bmf_row']? 1:-1
endfunction

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#sort(bmfOrder) 
"  /!\ values(bookmarkfancy_list[0])[0]['bmf_row'] donne la ligne du bookmark
"  à trier avec la fonction sort(..., n) n=tri numerique 1 < 11 !
"  ou avec une Funcref pour trier sur bmf_row
" dict2list avec perte de la clé dictionnaire (keys) 
" bmfOrder : ordre du tri 'ASC' ou 'DESC'
" return : une liste de liste (nested list)
" /!\ ALGO A REVOIR AVEC LA NVELLE STRUCT bookmarkfancy_list /!\
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
    return g:bmfList
    " let g:bmfList = []
    " let g:bmfListBuffer = []
    " let g:bmfDictBuffer = []
    " if a:bmfOrder ==# 'ASC'
    "     for key in keys(g:bookmarkfancy)->sort()
    "         echom g:bookmarkfancy[key]
    "         let g:bmfDictBuffer = g:bookmarkfancy[key]
    "         let g:bmfListBuffer = g:bmfListBuffer->add(g:bmfDictBuffer['bmf_row'])
    "                     \ ->add(g:bmfDictBuffer['bmf_sign'])
    "                     \ ->add(g:bmfDictBuffer['bmf_color'])
    "                     \ ->add(g:bmfDictBuffer['bmf_txt'])
    "                     \ ->add(g:bmfDictBuffer['bmf_timestamp'])
    "         \" let g:"bmfList->extend(g:bmfListBuffer)
    "         " echom g:bmfListBuffer
    "         let g:bmfDictBuffer = []
    "         let g:bmfList = g:bmfList->add(g:bmfListBuffer)
    "         let g:bmfListBuffer = []
    "     endfor
    "     echom \"DEBUG RESULT :" 
    "     echom g:bmfListBuffer
    "     echom \"___________________________"
    "     echom \"bmfList\n :"    
    "     echom g:bmfList
    "     for [lRow, lSign,lColor,lTxt,lTimestamp] in g:bmfList
    "         echom \"ligne : \" . lRow . \" color : " . lColor
    "     endfor
    "     echom \"END DEBUG"
    "     return g:bmfList
    " elseif a:bmfOrder ==# 'DESC'
    "     for key in keys(g:bookmarkfancy)->sort()->reverse()
    "         echom g:bookmarkfancy[key]
    "         let g:bmfDictBuffer = g:bookmarkfancy[key]
    "         let g:bmfListBuffer = g:bmfListBuffer->add(g:bmfDictBuffer['bmf_row'])
    "                     \ ->add(g:bmfDictBuffer['bmf_sign'])
    "                     \ ->add(g:bmfDictBuffer['bmf_color'])
    "                     \ ->add(g:bmfDictBuffer['bmf_txt'])
    "                     \ ->add(g:bmfDictBuffer['bmf_timestamp'])
    "         \" let g:"bmfList->extend(g:bmfListBuffer)
    "         " echom g:bmfListBuffer
    "         let g:bmfDictBuffer = []
    "         let g:bmfList = g:bmfList->add(g:bmfListBuffer)
    "         let g:bmfListBuffer = []
    "     endfor
    "     echom \"DEBUG RESULT :" 
    "     echom g:bmfListBuffer
    "     echom \"___________________________"
    "     echom \"bmfList\n :"    
    "     echom g:bmfList
    "     for [lRow, lSign,lColor,lTxt,lTimestamp] in g:bmfList
    "         echom \"ligne : \" . lRow . \" color : " . lColor
    "     endfor
    "     echom \"END DEBUG"
    "     return g:bmfList
    " endif
endfunction   
" }}}  

let &cpo = s:save_cpo
unlet s:save_cpo

" }}}
