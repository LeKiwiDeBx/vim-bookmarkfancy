"plugin bookmarkfancy
"View sign.vim
"
"
function! bmf_sign#create()
"
return v:true
endfunction

function! bmf_sign#init()
    call bmf_sign#highlights()
    sign define Bookmarkfancy texthl=BookmarkfancySign
    execute "sign define Bookmarkfancy text=". g:bmfflavors["normal"]["bmf_sign"]
endfunction

function! bmf_sign#highlights()
    highlight BookmarkfancySignDefault ctermfg=g:bmfflavors["normal"]["bmf_color"] ctermbg=NONE
    highlight default link BookmarkfancySign BookmarkfancySignDefault
endfunction

function! bmf_sign#place()

endfunction

