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
"/  "bmf_sign":"caractère du bookmark",
"/  "bmf_color" :"couleur",
"/  "bmf_txt": "texte",
"/  "bmf_timestamp":"timestamp"
"/ }
"structure texte --------------------------------------------------------------------------------------------
"pas de structure nécessaire a ce moment

"structure combo sign/color----------------------------------------------------------------------------------
"{"nom_du_combo":
"  {
"  "bmf_sign":"char du bmf",
"  "bmf_color": "couleur du bmf"
"  }
"}
let g:bmfflavors ={
                    \ "alert":{"bmf_sign":"","bmf_color":"red"},
                    \ "warning":{"bmfsign":"","bmf_color":"yellow"},
                    \ "notice":{"bmf_sign":"","bmf_color":"blue"}
                \ }
let g:bookmarkfancy = {}
"test de la structure ---------------------------------------------------------------------------------------
let g:bookmarkfancy= {1:{"bmf_row":1,"bmf_sign":"B","bmf_color" :"bleu", "bmf_txt": "LE TEXTE", "bmf_timestamp":0}}
let g:bookmarkfancy[2]= {"bmf_row":2,"bmf_sign":"B","bmf_color" :"blanc", "bmf_txt": "LE TEXTE", "bmf_timestamp":0}
let g:bookmarkfancy[3]= {"bmf_row":3,"bmf_sign":"B","bmf_color" :"rouge", "bmf_txt": "LE TEXTE", "bmf_timestamp":0}
function! s:init()
 if g:loaded_bookmarkfancy ==# 0
    call bookmarkfancy#init()
 endif
endfunction

"
" Ecrire fonction CRUD Create Read Update Delete
"Commands {{{
function! s:BookmarkFancyCreate()
    bookmarkfancy#create("currentRow")
endfunction

function! s:BookmarkFancyRead(line_number)
    if (line_number > 0 && line_number <= max_key_bookmarkfancy)
        bookmarkfancy#read(a:line_number)
    endif
endfunction

function! s:BookmarkFancyUpdate(line_number)
    bookmarkfancy#update(a:line_number)
endfunction

function! s:BoomarkFancyDelete(line_number)
    bookmarkfancy#delete(a:line_number)
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
