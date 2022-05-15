let g:loaded_bookmarkfancy = 0
"structure caractère du bookmark ----------------------------------------------------------------------------
"{1:'char_sign_1'}                                                          ⚑ ¶              
let g:bmfsigns={'bmfflag':'','bmfbookmark':'','bmfalt':'¶'}
"structure couleurs -----------------------------------------------------------------------------------------
"{"nom_couleur_bm":
"/ {
"/  "fg_term":"ctermfg",
"/  "fg_gui":"guifg"
"/ }
"/ }
let g:bmfcolors={"blue":{"fg_term":"21","fg_gui":"#0000FF"}}
"structure du dictionnaire ----------------------------------------------------------------------------------
"{numero_de_ligne:
"/ {
"/  "bmf_char":"caractère du bookmark",
"/  "bmf_col" :"couleur",
"/  "bmf_txt": "texte",
"/  "bmf_timestamp":"timestamp"
"/ }
"/ }
"structure texte --------------------------------------------------------------------------------------------
"pas de structure nécessaire a ce moment
let g:bookmarkfancy = {}
"test de la structure ---------------------------------------------------------------------------------------
let g:bookmarkfancy= {1:{"bmf_char":"B","bmf_col" :"blue", "bmf_txt": "LE TEXTE", "bmf_timestamp":0}}

function! s:init()
 if g:loaded_bookmarkfancy ==# 0
    call bookmarkfancy#init()
 endif
endfunction

"
" Ecrire fonction CRUD Create Read Update Delete
"Commands {{{
function! s:BookmarkFancyCreate()
    let currentRow = line(".")
    bookmarkfancy#create("currentRow")
endfunction

function! BookMarkFancyTest()
  echo bookmarkfancy#test()
endfunction
command! BookMarkFancyTest call BookMarkFancyTest()
"}}}

" Mapping {{{
execute "nnoremap <silent> <Plug>BookMarkFancyTest :BookMarkFancyTest<CR>"
if !hasmapto("<Plug>BookMarkFancyTest")
  execute "nmap bt <Plug>BookMarkFancyTest"
endif
"}}}

" Init {{{
if has('vim_starting')
  autocmd VimEnter * call s:init()
else
  call s:init()
endif
"}}}
