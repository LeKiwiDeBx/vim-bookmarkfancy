if exists('g:loaded_bookmarkfancy') || !has('signs') || &compatible || v:version < 700
    finish
endif   
let g:loaded_bookmarkfancy = 0 
let g:count = 0
"structure caractère du bookmark ----------------------------------------------------------------------------
"{1:'char_sign_1'}                                                          ⚑ ¶             
let g:bmfsigns={
            \ 'bmf_underline':{'bmf_flag':'','bmf_bookmark':'','bmf_alt':'¶'},
            \ 'bmf_bold':{'bmf_flag':'','bmf_bookmark':'','bmf_alt':'¶'},
            \ 'bmf_star':{'bmf_flag':'','bmf_bookmark':'','bmf_alt':'¶'}
            \ }
"structure couleurs -----------------------------------------------------------------------------------------
"{"nom_couleur_bm":
"/ {
"/  "fg_term":"ctermfg",
"/  "fg_gui":"guifg"
"/ }
"/ }
"if has("terminfo")
"    "use fg_term
"else
"    "use fg_gui
"endif    
let g:bmfcolors={
            \ "default":{"fg_term":"black","fg_gui":"#000000"},
            \ "normal":{"fg_term":"25","fg_gui":"#005FAF"},
            \ "notice":{"fg_term":"25","fg_gui":"#005FAF"},
            \ "warning":{"fg_term":"190","fg_gui":"#DFFF00"},
            \ "alert":{"fg_term":"160","fg_gui":"#D70000"},
            \ "pass":{"fg_term":"34","fg_gui":"#00AF00"}
            \ }
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
if &term=~'xterm'
    let g:bmf_fg= "fg_gui"
else
    let g:bmf_fg = "fg_term"
endif
let g:bmfflavors ={
            \ "alert":{"bmf_sign":g:bmfsigns["bmf_star"]["bmf_bookmark"],"bmf_color":g:bmfcolors["alert"][g:bmf_fg]},
            \ "warning":{"bmf_sign":g:bmfsigns["bmf_bold"]["bmf_bookmark"],"bmf_color":g:bmfcolors["warning"][g:bmf_fg]},
            \ "notice":{"bmf_sign":g:bmfsigns["bmf_underline"]["bmf_bookmark"],"bmf_color":g:bmfcolors["normal"][g:bmf_fg]},
            \ "normal":{"bmf_sign":g:bmfsigns["bmf_bold"]["bmf_bookmark"],"bmf_color":g:bmfcolors["normal"][g:bmf_fg]},
            \ "pass":{"bmf_sign":g:bmfsigns["bmf_star"]["bmf_bookmark"],"bmf_color":g:bmfcolors["pass"][g:bmf_fg]}
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
"Commands {{{
function! BookMarkFancyCreate(bmf_flavors = 'normal')
    call bmf_sign#init()
    let l:bmf_create = bookmarkfancy#create(bmf_sign#place(a:bmf_flavors),
                \ g:bmfflavors[a:bmf_flavors]['bmf_sign'],
                \ g:bmfflavors[a:bmf_flavors]['bmf_color'])
    eval g:bookmarkfancy_list->add(l:bmf_create)
    " écrire la fonction de vue sign#create(g:bookmarkfancy)
endfunction

function! s:BookmarkFancyRead(line_number)
    if (line_number > 0 && line_number <= max_key_bookmarkfancy)
        bookmarkfancy#read(a:line_number)
    endif
endfunction

function! s:BookmarkFancyUpdate(line_number)
    bookmarkfancy#update(a:line_number)
endfunction

function! s:BookmarkFancyDelete(line_number)
    bookmarkfancy#delete(a:line_number)
endfunction

function! BookMarkFancyRemove(line_number = 0)
    " version naïve :) test only
    let l:bmf_sign_id = bookmarkfancy#remove(a:line_number)
    echom 'bmf_sign_id :' . l:bmf_sign_id
    echom bmf_sign#unplace(l:bmf_sign_id) ==# 0 ? 'sign remove' : 'no action to do'
    return 1
endfunction

function! BookMarkFancyView()
    belowright copen
    call bookmarkfancy#view()
endfunction

function! BookMarkFancyTest()
    "echo bookmarkfancy#test()
    call bmf_sign#init()
    "echo bookmarkfancy#sort()
    "let l:id = bmf_sign#place()
    let g:bookmarkfancy_list = g:bookmarkfancy_list->add(bookmarkfancy#create(bmf_sign#place())) 
endfunction


function! BookMarkFancyFlavor(bmf_flavor = 'normal')
    "let g:oldwildmode = &wildmode 
    "set wildmode = longest:full, full
    call bookmarkfancy#flavor(a:bmf_flavor)
    "set wildmode = g:oldwildmode
endfunction

function! ListFlavors(A,L,P)
    return keys(g:bmfflavors)
endfunction

command! BookMarkFancyTest call BookMarkFancyTest()
command! BookMarkFancyCreate call BookMarkFancyCreate()
command! BookMarkFancyRemove call BookMarkFancyRemove()
command! BookMarkFancyView call BookMarkFancyView()
command! -nargs=? -complete=customlist,ListFlavors BookMarkFancyFlavor call BookMarkFancyFlavor(<f-args>)

"}}}

" Mapping {{{
"set wildmode=list:longest
execute "nnoremap <silent> <Plug>BookMarkFancyTest :BookMarkFancyTest<CR>"
if !hasmapto("<Plug>BookMarkFancyTest")
    execute "nmap bt <Plug>BookMarkFancyTest"
endif
execute "nnoremap <silent> <Plug>BookMarkFancyCreate :BookMarkFancyCreate<CR>"
if !hasmapto("<Plug>BookMarkFancyCreate")
    execute "nmap bc <Plug>BookMarkFancyCreate"
endif
execute "nnoremap <silent> <Plug>BookMarkFancyRemove :BookMarkFancyRemove<CR>"
if !hasmapto("<Plug>BookMarkFancyRemove")
    execute "nmap br <Plug>BookMarkFancyRemove"
endif
execute "nnoremap <silent> <Plug>BookMarkFancyView :BookMarkFancyView<CR>"
if !hasmapto("<Plug>BookMarkFancyView")
    execute "nmap bv <Plug>BookMarkFancyView"
endif
set wcm=<C-Z>
execute "nnoremap <Plug>BookMarkFancyFlavor :BookMarkFancyFlavor<space><C-Z><C-Z>"
if !hasmapto("<Plug>BookMarkFancyFlavor")
   execute "nmap bf <Plug>BookMarkFancyFlavor"
endif
"}}}

" Init {{{
if has('vim_starting')
    autocmd VimEnter * call s:init()
else
    call s:init()
endif
"}}}
