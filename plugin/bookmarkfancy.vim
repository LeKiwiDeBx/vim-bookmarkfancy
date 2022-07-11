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

let g:bmfcolors={
            \ "default":{"fg_term":"black","fg_gui":"#000000"},
            \ "normal":{"fg_term":"25","fg_gui":"#005FAF"},
            \ "notice":{"fg_term":"25","fg_gui":"#005FAF"},
            \ "warning":{"fg_term":"190","fg_gui":"#DFFF00"},
            \ "alert":{"fg_term":"160","fg_gui":"#D70000"},
            \ "pass":{"fg_term":"34","fg_gui":"#00AF00"}
            \ }

"if has("terminfo")
"    "use fg_term
"else
"    "use fg_gui
"endif
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

function! s:BookmarkFancyDelete(line_number)
    call bookmarkfancy#delete(a:line_number)
endfunction

function! BookMarkFancyFlavor(bmf_flavor = 'normal')
    "let g:oldwildmode = &wildmode
    "set wildmode = longest:full, full
    call bookmarkfancy#flavor(a:bmf_flavor)
    "set wildmode = g:oldwildmode
endfunction

function! BookMarkFancyLoad(bmf_file)
    call bmf_sign#init()
    call bookmarkfancy#load(a:bmf_file)
endfunction

function! s:BookmarkFancyRead(line_number)
    if (line_number > 0 && line_number <= max_key_bookmarkfancy)
        call bookmarkfancy#read(a:line_number)
    endif
endfunction

function! BookMarkFancyRemove(line_number = 0)
    let l:bmf_sign_id = bookmarkfancy#remove(a:line_number)
    echom bmf_sign#unplace(l:bmf_sign_id) ==# 0 ? 'sign remove at line ' .. a:line_number : 'no action to do'
    return 1
endfunction

function! BookMarkFancySave()
    call bmf_sign#sync()
    call bookmarkfancy#save()
endfunction

function! BookMarkFancyTest()
    call bmf_sign#init()
    let g:bookmarkfancy_list = g:bookmarkfancy_list->add(bookmarkfancy#create(bmf_sign#place()))
endfunction

function! BookMarkFancyUpdate()
    let l:result = bookmarkfancy#update()
    if l:result
        call bmf_sign#sync()
        call bookmarkfancy#view()
        echom "Update bookmarkfancy successfully"
    else 
        echom "Update bookmarkfancy failed"
    endif
endfunction

function! BookMarkFancyView()
    belowright copen
    call bmf_sign#sync()
    call bookmarkfancy#view()
endfunction

" functions annexes {{{
function! ListFlavors(A,L,P)
    return keys(g:bmfflavors)
endfunction

function! LoadFile(A,L,P)
    return globpath(&rtp, "**/*\.sav", 0, 1)->sort()->uniq() 
endfunction
"}}}

"Command {{{
command! BookMarkFancyCreate call BookMarkFancyCreate()
command! -nargs=? -complete=customlist,ListFlavors BookMarkFancyFlavor call BookMarkFancyFlavor(<f-args>)
command! -nargs=? -complete=customlist,LoadFile BookMarkFancyLoad call BookMarkFancyLoad(<f-args>)
command! BookMarkFancyRemove call BookMarkFancyRemove()
command! BookMarkFancySave call BookMarkFancySave()
command! BookMarkFancyTest call BookMarkFancyTest()
command! BookMarkFancyUpdate call BookMarkFancyUpdate()
command! BookMarkFancyView call BookMarkFancyView()
"}}}

" Mapping {{{
set wcm=<C-Z>
" bc Create
execute "nnoremap <silent> <Plug>BookMarkFancyCreate :BookMarkFancyCreate<CR>"
if !hasmapto("<Plug>BookMarkFancyCreate")
    execute "nmap bc <Plug>BookMarkFancyCreate"
endif
" bf Flavor
execute "nnoremap <Plug>BookMarkFancyFlavor :BookMarkFancyFlavor<space><C-Z><C-Z>"
if !hasmapto("<Plug>BookMarkFancyFlavor")
    execute "nmap bf <Plug>BookMarkFancyFlavor"
endif
" bl Load
execute "nnoremap <Plug>BookMarkFancyLoad :BookMarkFancyLoad"
if !hasmapto("<Plug>BookMarkFancyLoad")
    execute "nmap bl <Plug>BookMarkFancyLoad"
endif
" br Remove
execute "nnoremap <silent> <Plug>BookMarkFancyRemove :BookMarkFancyRemove<CR>"
if !hasmapto("<Plug>BookMarkFancyRemove")
    execute "nmap br <Plug>BookMarkFancyRemove"
endif
" bs Save
execute "nnoremap <silent> <Plug>BookMarkFancySave :BookMarkFancySave<CR>"
if !hasmapto("<Plug>BookMarkFancySave")
    execute "nmap bs <Plug>BookMarkFancySave"
endif
" bt Test
execute "nnoremap <silent> <Plug>BookMarkFancyTest :BookMarkFancyTest<CR>"
if !hasmapto("<Plug>BookMarkFancyTest")
    execute "nmap bt <Plug>BookMarkFancyTest"
endif
" bu Update
execute "nnoremap <silent> <Plug>BookMarkFancyUpdate :BookMarkFancyUpdate<CR>"
if !hasmapto("<Plug>BookMarkFancyUpdate")
    execute "nmap bu <Plug>BookMarkFancyUpdate"
endif
" bv View
execute "nnoremap <silent> <Plug>BookMarkFancyView :BookMarkFancyView<CR>"
if !hasmapto("<Plug>BookMarkFancyView")
    execute "nmap bv <Plug>BookMarkFancyView"
endif
"}}}

" Init {{{
if has('vim_starting')
    autocmd VimEnter * call s:init()
else
    call s:init()
endif

" autocmd InsertLeave,BufWritePost  * call BookMarkFancyView()
"}}}
