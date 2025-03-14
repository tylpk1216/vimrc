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
let mapleader = ","
inoremap jk <esc>

if has('unix')
    nnoremap cmd:silent !gnome-terminal &<CR>
else
    nnoremap cmd:silent !"C:\ProgramFiles\Git\bin\bash.exe"<CR><CR>
endif

nnoremap <leader>ev :vsplit $MYVIMRC<CR> 
nnoremap <leader>n <C-f>
nnoremap <leader>m <C-b>

" status line
set laststatus=2
set statusline=%F\ %=%y[Col:%v][Row:%l/%L]

" adjust theme (ctermbg/guibg)
hi Comment guibg=#808080
hi Comment guifg=#0000A0 gui=bold

" status line
hi StatusLine guibg=#808080
hi StatusLine guifg=#0000A0 gui=bold

" normal text/backgound
hi Normal guifg=#ffffff guibg=#000000
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
augroup coding_group
    autocmd!
    autocmd FileType python setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd BufWritePost *.vimrc source %
    autocmd BufWritePre * silent! :%s/\v\s+$//g
augroup END

" for tmux
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

