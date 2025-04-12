" ------------ global variables ------------
let g:netrw_keepdir = 0
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_browse_split = 3

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
nnoremap <leader>sh :set syntax=sh<CR>
nnoremap <leader>gf <C-w>gf
" select, search word
nnoremap <leader>sw viw y
nnoremap <leader>fw viw y /<C-r><S-"><CR>
nnoremap <leader>module <S-v>/endmodule<CR>y :call OpenModuleFile()<CR>
nnoremap <leader>cc :call SetColorColumn()<CR>
nnoremap <leader>dc :set colorcolumn=0<CR>
nnoremap <leader>fm :Vex<CR>

" status line
set laststatus=2

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

" netrw                        
hi MKExe ctermfg=lightgreen    
hi Directory ctermfg=lightblue
hi link netrwExe MKExe 

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

" ------------ functions  ------------
function OpenModuleFile()
    let l:line = substitute(getline("."), "(", " ", "")
    let l:strs = split(l:line)

    let l:fname = "tmp"
    if len(l:strs) >= 2
        let l:fname = strs[1]
    endif

    execute ":tabe " . l:fname . ".v"
    normal! p
    execute ":set syntax=verilog"
endfunction

function SetColorColumn()
    let l:cursor = getops(".")
    execute ":set colorcolumn=" . l:cursor[2]
endfunction

function GetCurrNetrwFile()
    let l:s = expand("%:p") . getline(".")
    echo l:s
endfunction

function SetStatusLine()
    if &ft == "netrw"
	execute ":set statusline=%F\\" . " %=%y[Col:%v][Row:%l/%L]e " 	
    endif
endfunction
