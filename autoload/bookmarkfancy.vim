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
" function! bookmarkfancy#save()
"
" sauvegarde les bookmarks
" return : true or false ;)
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#save()
    "writefile /readfile
    const l:file = "bmf_bookmarks.sav"
    let l:directory = expand('%:p:h')
    if l:directory->filewritable()
        let l:file_save = l:directory."/".l:file
        if writefile([json_encode(copy(g:bookmarkfancy_list))], l:file_save, "s") ==# -1
            echom "Save File Error"
            return v:false
        else
            echom "Save File Success"
        endif
    endif
    return v:true
endfunction    

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#load()
"
" restore les bookmarks
" return : rien 
" !!!!!!!!!! writing in progress...
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#load(bmfFile) "{{{
    " fonctions utiles winbufnr() bufnr() bufwinid() bufwinnr() bufname() bufexists() bufloaded(nomm complet fichier)
    " getbufinfo().name ie
    " sign_placelist({list})
    " liste des buffers en cours
    "  map(getbufinfo({'buflisted': 1}), 'v:val.name')
    "  avec filter
    "  map(filter(copy(getbufinfo()), 'v:val.listed'), 'v:val.name')
    let l:isload = v:false
    let g:bookmarkfancy_list = []
    let l:buf_list = map(getbufinfo({'buflisted': 1}), 'v:val.name')
    let bufnrlist = []
    let l:bookmarkfancy_sav_list = eval(readfile(a:bmfFile)[0]) 
    for dict in l:bookmarkfancy_sav_list
        let [l:bmf_file_key, l:bmf_file] =[keys(dict)[0], values(dict)[0]]
        for buf_name in l:buf_list
            if buf_name ==# l:bmf_file.bmf_file
                let l:bnr = bufnr(l:bmf_file.bmf_file) 
                call add(l:bufnrlist,l:bnr) 
                let l:bmfSignId = sign_place(0, '', l:bmf_file.bmf_sign_name, l:bnr, {'lnum':l:bmf_file.bmf_row}) 
                call add(g:bookmarkfancy_list, bookmarkfancy#restore(dict, l:bmfSignId, l:bnr))
                let l:isload = v:true
            endif
        endfor
    endfor
    return l:isload 
endfunction
" }}}

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#restore()
" 
" retablit un bookmark à partir de la liste des bookmarks, et modifie l'Id du signe et le buffer
" en cours
" bmfSaveList: liste sauvée
" bmfSignId: l'id du sign recréé
" bmfBuffer: le buffer en cours corrrespondant pour le bookmark
" return: le bookmark à inserer dans la liste
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#restore(bmfSaveList, bmfSignId, bmfBuffer) "{{{
    let l:bmf = values(a:bmfSaveList)[0]
    let l:key_row = keys(a:bmfSaveList)[0]
    let  l:bmf  = {l:key_row: 
                \  {'bmf_row':l:bmf.bmf_row,
                \  'bmf_sign_id': a:bmfSignId,
                \  'bmf_sign':l:bmf.bmf_sign,  
                \  'bmf_sign_name':l:bmf.bmf_sign_name,
                \  'bmf_color':l:bmf.bmf_color,
                \  'bmf_txt':l:bmf.bmf_txt,
                \  'bmf_buffer':a:bmfBuffer,
                \  'bmf_file':l:bmf.bmf_file,
                \  'bmf_status':l:bmf.bmf_status,
                \  'bmf_timestamp':l:bmf.bmf_timestamp
                \  }
                \ }
    return l:bmf
endfunction
"}}}

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
    let bmfSignName = sign_getplaced('',{'id': a:bmfSignId})[0]['signs'][0]['name'] 
    let bmfColor = a:bmf_color->empty() ? g:bmfflavors["normal"]["bmf_color"] : a:bmf_color 
    let g:currentText = (g:currentRow->getline())->trim()->strcharpart(idx, g:max_lenght)
    let g:currentBuffer = bufnr()
    let g:currentFile = expand("%:p")    
    let g:currentStatus = 1 "status = 0: disabled, 1: enabled"
    let g:timeStamp = localtime()
    let g:bookmarkfancy = {g:currentRow: 
                \              {'bmf_row':g:currentRow,
                \               'bmf_sign_id': a:bmfSignId,
                \               'bmf_sign':bmfSign,  
                \               'bmf_sign_name':bmfSignName,
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
function! bookmarkfancy#flavor(bmf_flavor = 'normal') "{{{
    let g:count += 1
    let g:currentRow = line(".")
    let l:idx = 0
    let l:flavor = g:bmfflavors->has_key(a:bmf_flavor)? a:bmf_flavor : 'normal'
    for bookmarkfancy_dict in g:bookmarkfancy_list
        if values(bookmarkfancy_dict)[0]['bmf_row'] ==# g:currentRow
            let bmf_sign_id =  values(bookmarkfancy_dict)[0]['bmf_sign_id']
            let bmf_key = keys(bookmarkfancy_dict)[0]
            call bmf_sign#place(a:bmf_flavor, bmf_sign_id)
            let bmf_sign_name = sign_getplaced('',{'id':bmf_sign_id})[0]['signs'][0]['name'] 
            let g:bookmarkfancy_list[l:idx][bmf_key].bmf_sign_name = bmf_sign_name
            let g:bookmarkfancy_list[l:idx][bmf_key].bmf_sign = g:bmfflavors[l:flavor]["bmf_sign"]
            let g:bookmarkfancy_list[l:idx][bmf_key].bmf_color = g:bmfflavors[l:flavor]["bmf_color"]
        endif
        let l:idx += 1
    endfor 
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
            call remove(g:bookmarkfancy_list, l:idx)
            return  values(bookmarkfancy_dict)[0]['bmf_sign_id']
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
" return: rien
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#view(how = 'ALL') "{{{
    const title = "bookmarkfancy's signs"
    let qflist = []
    for bmf_dic in g:bookmarkfancy_list
        for val in values(bmf_dic)
            let dx_items = {'lnum':val['bmf_row'], 'text':val['bmf_txt'], 'bufnr':val['bmf_buffer']}
            call add(qflist, dx_items)
        endfor
    endfor
    call setqflist([],'r',{'items':qflist, 'title':title})
    call setqflist(getqflist()->sort({l1,l2 -> l1.lnum - l2.lnum}), 'r')
endfunction
"}}}

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#update()
" mise a jour du bmf 
" param: par defaut ligne en cours et remplacement du texte du bookmark (what else?)
" return: boolean success or not
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#update(bmfLineNumber = 0, what = 'bmf_txt') "{{{
    let g:currentRow = a:bmfLineNumber ==# 0 ? line(".")  : a:bmfLineNumber 
    let l:found = v:false
    for bmf_dic in g:bookmarkfancy_list
        for val in values(bmf_dic)
            if val['bmf_row'] == g:currentRow 
                if a:what ==# 'bmf_txt'
                    call inputsave()
                    let FuncVal = {-> val['bmf_txt']}
                    let l:text = input("Replace the comment (use completion): ","", "custom,FuncVal")
                    call inputrestore()       
                    let val['bmf_txt'] = l:text
                    let l:found = v:true
                endif
            endif
        endfor
    endfor
    return l:found
endfunction 
" }}}

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! CompareRow(row1, row2)
" classement des lignes par ordre croissant
" return: fonction annexe
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! CompareRow(row1, row2) "{{{ 
    return a:row1[0]['bmf_row'] == a:row2[0]['bmf_row']? 0:a:row1[0]['bmf_row'] >a:row2[0]['bmf_row']? 1:-1
endfunction
"}}}

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
    return g:bmfList
endfunction   
" }}}  

let &cpo = s:save_cpo
unlet s:save_cpo

" }}}
