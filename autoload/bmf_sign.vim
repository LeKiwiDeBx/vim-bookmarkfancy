function! bmf_sign#init()
    echo "Sign initialized"
    call bmf_sign#highlights()
    sign define sign_normal texthl=BookmarkfancySign
    execute "sign define sign_normal text=" . g:bmfflavors["normal"]["bmf_sign"]
endfunction
     
function! bmf_sign#highlights(flavor_name = "normal")
    echo "Sign highlighted"
    let term_fg_flavor = g:bmfflavors[a:flavor_name]["bmf_color"]["cterm"] 
    let gui_fg_flavor = g:bmfflavors[a:flavor_name]["bmf_color"]["gui"] 
    echom "flavor : term=" . term_fg_flavor ."  gui=".gui_fg_flavor
    "highlight link BookmarkfancySignDefault SignColumn
    " couleur du fond de la colonne signe: SynIDattr(hlID('SignColumn'),'bg')
    execute "highlight BookmarkfancySign ctermfg=".. term_fg_flavor .." guifg=".. gui_fg_flavor 
    highlight default link BookmarkfancySign SignColumn 
endfunction

function! bmf_sign#place()
    let g:currentRow = line(".")
    "execute \" \""sign place 1 line=7 name=sign_normal"
    let id = sign_place(0, '','sign_normal', 6,{'lnum':g:currentRow})  
    echom "id sign : " . id
endfunction
