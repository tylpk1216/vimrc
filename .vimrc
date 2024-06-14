" ------------ general settings ------------
set tabstop=4
set nu
set ai
set title
set showcmd
set backspace=indent,eol,start
"set mouse=a

" ------------ displaying ------------
syntax on
set termguicolors
set hlsearch
colorscheme desert

if has('unix')
    set guifont=Monospace\ 12
else
    set guifont=Courier_New:h18
endif

" max gui window
au GUIEnter * simalt ~x

" re-map key
inoremap jk <esc>

" adjust theme (ctermbg/guibg)
hi Comment guibg=#808080
hi Comment guifg=#0000A0 gui=bold
" the color below the last line of file
hi NonText guibg=#000000
" function name
hi Identifier guifg=white
" string
hi Constant guifg=#FF0000
" #include
hi PreProc guifg=#008888
" return, if, else
hi Statement guifg=#008888
" int, void
hi Type guifg=#008888
" \n
hi Special guifg=#FF0000

" ------------ for coding ------------
autocmd FileType python setlocal shiftwidth=4 softtabstop=4 expandtab
