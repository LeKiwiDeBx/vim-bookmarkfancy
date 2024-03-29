" {{{
let s:save_cpo = &cpo
set cpo&vim

"if exists('g:loaded_bookmarkfancy')
" finish
"endif

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
    let g:bookmarkfancy = {
                \ g:currentRow:{'bmf_row' : g:currentRow,
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
" bmfSign:     un dictionnaire caractère symbolique
" bmfColor:    un dictionnaire couleur du symbole
" return:      rien
" TODO externaliser dans le plugin la demande de 3 parametres pour creer bmfSign et bmfColor
"  /!\ nom [nom de la saveur /ou automatique ] ei: flavor_001  ou 10 char
"  sign [symbole  -complete=list avec input]   ei: let bmf_symb = [, , , ¶, , , , , , , , , , , , , ]
"  color [couleur -complete=list avec input] /!\
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! ListSymb(A, L, P)
    return  g:bmf_symb->sort()->uniq()
endfunction

function! ListColor(ArgLead, CmdLine, CursorPos)
    :redraw
    return copy(g:bmf_color)->filter('v:val =~ "' . a:ArgLead . '"')->sort()
endfunction

function! s:doSign(bmfSignSymbol)
    return {'bmf_custom':{'bmf_flag': '', 'bmf_bookmark': a:bmfSignSymbol, 'bmf_alt': '¶'}}
endfunction

function! s:doColor(bmfColor)
    let l:dic_color = {"black":"#000000","maroon":"#800000" ,"green":"#008000","olive":"#808000","navy":"#000080","purple":"#800080","teal":"#008080","silver":"#C0C0C0","grey":"#808080","red":"#FF0000","lime":"#00FF00","yellow":"#FFFF00","blue":"#0000FF","fuschia":"#FF00FF","aqua":"00FFFF","white":"#FFFFFF"}
    return {"custom":{"fg_term":a:bmfColor,"fg_gui":l:dic_color[a:bmfColor]}}
endfunction

function! bookmarkfancy#design(bmfSign = "X", bmfColor = "#0000FF") "{{{
    call extend(g:bmfsigns, a:bmfSign)
    call extend(g:bmfcolors, a:bmfColor)
    call extend(g:bmfflavors, {keys(a:bmfColor)[0]:
                \ {"bmf_sign":g:bmfsigns[keys(a:bmfSign)[0]]["bmf_bookmark"],
                \  "bmf_color":g:bmfcolors[keys(a:bmfColor)[0]][g:bmf_fg]
                \ }
                \ })
endfunction
" }}}

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#new()
"
" créée un nouveau bookmark à partir d'une liste signes/couleurs et l'ajoute à liste des saveurs
" return : rien
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#new() "{{{
    call inputsave()
    let choiceSign = input("choice the sign: ", "", "customlist,ListSymb")
    call inputrestore()
    :redraw
    call inputsave()
    let choiceColor = input("choice the color: ", "", "customlist,ListColor")
    call inputrestore()
     if(g:bmf_symb->index(choiceSign) ==# -1 || g:bmf_color->index(choiceColor) ==# -1)
         echo "\r"
         redraw
         echom "Symbol or/and color not legal values!"
         return v:false
     else
        call bookmarkfancy#design(s:doSign(choiceSign), s:doColor(choiceColor))
     endif
     return v:true
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
" function! bookmarkfancy#init()
"
" quelques init (to completed)
" return:
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#init() "{{{
    let g:loaded_bookmarkfancy = 1
    let g:bookmarkfancy_list = []
    let g:idxName = 0
endfunction
"}}}

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
    try
        let l:bookmarkfancy_sav_list = eval(readfile(a:bmfFile)[0])
    for dict in l:bookmarkfancy_sav_list
        let [l:bmf_file_key, l:bmf_file] =[keys(dict)[0], values(dict)[0]]
        echom l:bmf_file.bmf_file .. "\n"
        if l:bmf_file.bmf_file ==# expand("%:p") 
            echom 'OK loading bookmarks of file: ' .. l:bmf_file.bmf_file
        else
            echom 'ERROR loading bookmarks of file'
            continue
        endif    
        for buf_name in l:buf_list
            if buf_name ==# l:bmf_file.bmf_file
                let l:bnr = bufnr(l:bmf_file.bmf_file)
                let l:row = l:bmf_file.bmf_row
                call add(l:bufnrlist,l:bnr)
                let l:bmfSignId = sign_place(0, '', l:bmf_file.bmf_sign_name, l:bnr, {'lnum':l:row})
                let g:bmf_restore = bookmarkfancy#restore(dict, l:bmfSignId, l:bnr)
                let g:key = keys(g:bmf_restore)
                if g:bmf_restore[g:key[0]].bmf_sign_name ==# 'sign_custom'
                   let l:sign = g:bmf_restore[g:key[0]].bmf_sign
                   let l:color = {"custom":{"fg_gui":g:bmf_restore[g:key[0]].bmf_color}} 
                   call bookmarkfancy#design(s:doSign(l:sign), l:color) 
                endif
                call add(g:bookmarkfancy_list, g:bmf_restore)
                let l:isload = v:true
            endif
        endfor
    endfor
    return l:isload
    catch 
        echom "Error with readfile(), may be not file exists."
    finally
    return l:isload
    endtry
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
" function! bookmarkfancy#save()
"
" sauvegarde les bookmarks
" return : true or false ;)
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! Only_me(idx, val) "{{{
  let l:file_local = expand('%:p')
  for dict in values(a:val)
    "echom dict.bmf_file
    return dict.bmf_file ==# l:file_local
  endfor
endfunction
"}}}
"
function! bookmarkfancy#save() "{{{
    " const l:file = "bmf_bookmarks.sav"
    let l:directory = expand('%:p:h')
    if l:directory->filewritable()
        "let l:file_save = l:directory."/".l:file
        "TODO
        "enregistrer que les bookmarks du fichier en cours
        let l:file_save = expand('%:p') .. '.bmk' "un fichier de bookmarks par fichier concerné
        let l:bmf_list_filter = copy(g:bookmarkfancy_list)->filter(function('Only_me'))  
"        echom "list_filter: "
"        echom l:bmf_list_filter
        "if writefile([json_encode(copy(g:bookmarkfancy_list))], l:file_save, "s") ==# -1
        if writefile([json_encode(copy(l:bmf_list_filter))], l:file_save, "s") ==# -1
            echom "Error unable to write bookmarks file "..l:file_save
            return v:false
        else
            echom "Bookmarks from current file are successfully written to: " .. l:file_save
        endif
    endif
    return v:true
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

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bookmarkfancy#test()
" Hum? a test may be...
" return:
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bookmarkfancy#test() "{{{
    return "This is bookmarkfancy vim plugin :)"
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
    call setqflist([],'r',{'items':qflist, 'title':title, 'idx':'$'})
    call setqflist(getqflist()->sort({l1,l2 -> l1.lnum - l2.lnum}), 'r')
endfunction
"}}}

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! CompareRow(row1, row2)
" classement des lignes par ordre croissant
" return: fonction annexe
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! CompareRow(row1, row2) "{{{
    return a:row1[0]['bmf_row'] == a:row2[0]['bmf_row']? 0:a:row1[0]['bmf_row'] >a:row2[0]['bmf_row']? 1:-1
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
