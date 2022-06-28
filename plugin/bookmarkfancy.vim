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
endfunction

function! s:BookmarkFancyRead(line_number)
    if (line_number > 0 && line_number <= max_key_bookmarkfancy)
        call bookmarkfancy#read(a:line_number)
    endif
endfunction

function! s:BookmarkFancyUpdate(line_number)
    call bookmarkfancy#update(a:line_number)
endfunction

function! s:BookmarkFancyDelete(line_number)
    call bookmarkfancy#delete(a:line_number)
endfunction

function! BookMarkFancyRemove(line_number = 0)
    " version naïve :) test only
    let l:bmf_sign_id = bookmarkfancy#remove(a:line_number)
    echom bmf_sign#unplace(l:bmf_sign_id) ==# 0 ? 'sign remove' : 'no action to do'
    return 1
endfunction

function! BookMarkFancyView()
    belowright copen
    call bmf_sign#sync()
    call bookmarkfancy#view()
endfunction

function! BookMarkFancyTest()
    call bmf_sign#init()
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
"
" Init {{{
if has('vim_starting')
    autocmd VimEnter * call s:init()
else
    call s:init()
endif

autocmd InsertLeave,BufWritePost  * call BookMarkFancyView()
"}}}
