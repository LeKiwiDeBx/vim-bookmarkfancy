function! bmf_sign#init()
    echo "Sign initialized"
    call bmf_sign#highlights()
    sign define sign_normal texthl=BookmarkfancySign
    " faire une fonction map \"sign_" . g:bmfflavors["suffix_sign"]
    " map(keys(copy(bmfflavors)), {_, val -> 'sign_' .. val}):
    " let list = keys(copy(bmfflavors))->map('"sign_" .. v:val')"
    execute "sign define sign_normal text=" . g:bmfflavors["normal"]["bmf_sign"]
endfunction

function! bmf_sign#highlights(flavor_name = "normal")
    echo "Sign highlighted"
    let term_fg_flavor = g:bmfflavors[a:flavor_name]["bmf_color"]["cterm"] 
    let gui_fg_flavor = g:bmfflavors[a:flavor_name]["bmf_color"]["gui"] 
    echom "flavor : term=" . term_fg_flavor ."  gui=".gui_fg_flavor
    "highlight link BookmarkfancySignDefault SignColumn
    " couleur du fond de la colonne signe: SynIDattr(hlID('SignColumn'),'bg')
    let term_bg_flavor = synIDattr(hlID('SignColumn'), 'bg','cterm')
    let gui_bg_flavor  = synIDattr(hlID('SignColumn'), 'bg#','gui')
    execute "highlight BookmarkfancySignDefault ctermfg=".. term_fg_flavor .." guifg=".. gui_fg_flavor ..
                \ " ctermbg=".. term_bg_flavor .." guibg=".. gui_bg_flavor
    highlight default link BookmarkfancySign  BookmarkfancySignDefault
endfunction

function! bmf_sign#sync(buf_name ='') 
    """ <= => != -> -- __ == ==="
    let g:buf = a:buf_name->empty()? bufname("%") : a:buf_name
    let g:sign_list = g:buf->sign_getplaced()[0]['signs']
    "liste de dictionnaires de signe du buffer
    echom " Liste de dictionnaires de signes = " 
    echom g:sign_list
endfunction 

function! bmf_sign#place(bmf_flavor = 'normal')
    let g:currentRow = line(".")
    let g:bmf_create = []
    "execute \" \""sign place 1 line=7 name=sign_normal"
    let g:buf = bufnr(expand("%:p")) 
    let id = sign_place(0, '','sign_normal', g:buf, {'lnum':g:currentRow})  
    echom "id sign : " . id
    "# TODO: mise a jour dictionnaire bookmarkfancy dans bookmarkfancy.vim 
    let g:bookmarkfancy_list = g:bookmarkfancy_list->add(bookmarkfancy#create(id))
endfunction
