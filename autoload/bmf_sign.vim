"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" function! bmf_sign#init()
" initialisation des noms de sign aux saveurs (flavors)
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bmf_sign#init() "{{{
    call bmf_sign#highlights()
    for sufx in keys(copy(g:bmfflavors))->map('v:val')
        execute "sign define sign_" . sufx . "  texthl=BookmarkfancySign". sufx ." text=" . g:bmfflavors[sufx]["bmf_sign"]
    endfor
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
" function! bmf_sign#highlights()
" attribut la colorisation des signes (foreground et background)
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bmf_sign#highlights(flavor_name = "normal") "{{{
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
    endfor
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
" function! bmf_sign#sync()
" synchronise la liste des bookmarks avec nouvelle position des signes
" cas des ajout/suppression de ligne
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bmf_sign#sync(buf_name ='')
    let g:buf = a:buf_name->empty()? bufname("%") : a:buf_name
    let g:sign_list = sign_getplaced()
    for signdic in g:sign_list
        let iddx = 0
        while iddx <# len(signdic['signs'])
            let [sid, slnum] = [signdic['signs'][iddx].id, signdic['signs'][iddx].lnum]
            let bmfidx = 0
            for bmfdict in g:bookmarkfancy_list
                if values(bmfdict)[0]['bmf_sign_id'] ==# sid
                    let v = values(g:bookmarkfancy_list[bmfidx])[0]
                    let v['bmf_row'] = slnum
                endif
                let bmfidx += 1
            endfor
            let iddx += 1
        endwhile
    endfor
endfunction

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
" function! bmf_sign#place()
" positionne un signe à la position en cours
" return: id unique du signe
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bmf_sign#place(bmf_flavor = 'normal', bmf_sign_id = 0, bmf_buffer = 0 ) "{{{
    let g:currentRow = line(".")
    let g:bmf_create = []
    let g:buf = a:bmf_buffer ==# 0? bufnr(expand("%:p")) : a:bmf_buffer
    let l:sign_name = g:bmfflavors->has_key(a:bmf_flavor)? 'sign_' . a:bmf_flavor : 'sign_normal'
    let id = sign_place(a:bmf_sign_id, '', l:sign_name, g:buf, {'lnum':g:currentRow})
    return id
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
" function! bmf_sign#unplace()
" enleve le signe de tous les buffers
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function! bmf_sign#unplace(bmf_sign_id = 0) abort "{{{
    try
        exe "silent! call sign_unplace('*', {'id' : a:bmf_sign_id})"
    catch /.*/
        echom 'DEBUG :: ERREUR :( bmf_sign_id = ' .. a:bmf_sign_id
        echoerr v:exception
    finally
        "echom "id :".a:bmf_sign_id
    endtry
endfunction
"}}}
