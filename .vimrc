" general settings
set tabstop=4
set nu
set ai
set title
set showcmd
"set mouse=a

" displaying
syntax on
set termguicolors
colorscheme xxx
set guifont=Monospace\ 12

" re-map key
inoremap jk <esc>

" adjust theme
hi Comment ctermbg=darkgray
hi Comment ctermfg=lightblue
" the color below the last line of file
hi NonText guibg=#000000
" function name
hi Identifier guifg=#00BFBF
" string
hi Constant guifg=#FF0000

" for coding
autocmd FileType python set expandtab
