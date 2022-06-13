function! bmf_sign#init()
    "echo "Sign initialized"
    call bmf_sign#highlights()
    for sufx in keys(copy(g:bmfflavors))->map('v:val')
        execute "sign define sign_" . sufx . "  texthl=BookmarkfancySign". sufx ." text=" . g:bmfflavors[sufx]["bmf_sign"]
    endfor
endfunction

function! bmf_sign#highlights(flavor_name = "normal")
    " echo "Sign highlighted"
    " TODO passer toutes les 'bmfflavors' en highlight pour ctermfg et guifg
    let gui_fg_flavor = g:bmfcolors["default"]["fg_gui"]
    let term_fg_flavor = g:bmfcolors["default"]["fg_term"]
    if &term=~'xterm'
        let gui_fg_flavor = g:bmfflavors[a:flavor_name]["bmf_color"]
    else
        let term_fg_flavor = g:bmfflavors[a:flavor_name]["bmf_color"]
    endif
    let term_bg_flavor = synIDattr(hlID('SignColumn'), 'bg','cterm')
    let gui_bg_flavor  = synIDattr(hlID('SignColumn'), 'bg#','gui')
    execute "highlight BookmarkfancySignDefault ctermfg=".. term_fg_flavor .." guifg=".. gui_fg_flavor ..
                \ " ctermbg=".. term_bg_flavor .." guibg=".. gui_bg_flavor
    highlight default link BookmarkfancySign  BookmarkfancySignDefault
    for sufx in keys(copy(g:bmfflavors))->map('v:val')
        if &term=~'xterm'
            let gui_fg_flavor = g:bmfflavors[sufx]["bmf_color"]
        else
            let term_fg_flavor = g:bmfflavors[sufx]["bmf_color"]
        endif
        execute "highlight BookmarkfancySign"..sufx.." ctermfg=".. term_fg_flavor .." guifg=".. gui_fg_flavor ..
                    \ " ctermbg=".. term_bg_flavor .." guibg=".. gui_bg_flavor
       " highlight default link BookmarkfancySign  BookmarkfancySignDefault
    endfor
endfunction

function! bmf_sign#sync(buf_name ='')
    let g:buf = a:buf_name->empty()? bufname("%") : a:buf_name
    let g:sign_list = g:buf->sign_getplaced()[0]['signs']
    "liste de dictionnaires de signe du buffer
    echom " Liste de dictionnaires de signes = "
    echom g:sign_list
    echom g:bookmarkfancy_list
endfunction

function! bmf_sign#place(bmf_flavor = 'normal')
    let g:currentRow = line(".")
    let g:bmf_create = []
    let g:buf = bufnr(expand("%:p"))
    let l:sign_name = g:bmfflavors->has_key(a:bmf_flavor)? 'sign_' . a:bmf_flavor : 'sign_normal'
    " parametrer nom du sign en fonction de la flavor 'sign_'..['normal','alert',..]
    let id = sign_place(0, '', l:sign_name, g:buf, {'lnum':g:currentRow})
    "echom "id sign : " . id
    "# TODO: mise a jour dictionnaire bookmarkfancy dans bookmarkfancy.vim
    return id
endfunction
