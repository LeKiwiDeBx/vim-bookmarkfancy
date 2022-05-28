function! bmf_sign#init()
    echo "Sign initialized"
    call bmf_sign#highlights()
    sign define sign_normal texthl=BookmarkfancySign
    execute "sign define sign_normal text=" . g:bmfflavors["normal"]["bmf_sign"]
endfunction

function! bmf_sign#highlights(flavor_name = "normal")
    echo "Sign highlighted"
    let fg_flavor = '"' . g:bmfflavors[a:flavor_name]["bmf_color"] . '"'
    echom "flavor : " . fg_flavor
    execute "highligh BookmarkfancySignDefault ctermfg=21 ctermbg=NONE"
    highlight default link BookmarkfancySign BookmarkfancySignDefault
endfunction

function! bmf_sign#place()
    let g:currentRow = line(".")
    call sign_place(0, 'bmfSignGrp','sign_normal', 6,{'lnum':g:currentRow, 'priority' : 100})    
endfunction"
