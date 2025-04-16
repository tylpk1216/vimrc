" ------------ global variables ------------
let g:netrw_keepdir = 0
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_browse_split = 3

let s:MK_set_winwidth = 0
let s:MK_winwidth = 100
" use it to prevent from losing cursor when netrw open tab and quit.
let s:MK_restore_count = 0

" ------------ general settings ------------
set tabstop=4
set nu
set ai
set title
set showcmd
set backspace=indent,eol,start
set splitright
"set mouse=a


" ------------ re-map keys ------------
let mapleader = ","
inoremap jk <esc>
nnoremap t '
nnoremap <leader>ev :call <SID>OpenFileToRight($MYVIMRC)<CR>
nnoremap <leader>n <C-f>
nnoremap <leader>m <C-b>
nnoremap <leader>sh :set syntax=sh<CR>
nnoremap <leader>gf <C-w>gf
" select, search word
nnoremap <leader>fw viwy /<C-r><S-"><CR>
nnoremap <leader>module <S-v>/endmodule<CR>y :call <SID>OpenModuleFile()<CR>
nnoremap <leader>cc :call <SID>SetColorColumn()<CR>
nnoremap <leader>dc :set colorcolumn=0<CR>
nnoremap <leader>fm :Vex<CR>
nnoremap <leader>o :call <SID>OpenFileToRight(<SID>GetCurrNetrwFile())<CR>


" ------------ displaying ------------
syntax on
set hlsearch
colorscheme desert

if has('unix')
    set guifont=Monospace\ 12
else
    set termguicolors
    set guifont=Courier_New:h18
endif

" max gui window
au GUIEnter * simalt ~x

" status line
set laststatus=2

" adjust theme (ctermbg/guibg)
if has('unix') && !has('win32unix')
    hi Comment ctermbg=lightgray
    hi Comment ctermfg=black cterm=bold

    hi StatusLine ctermbg=lightgray
    hi StatusLine ctermfg=black cterm=bold

    " function name
    hi Identifier ctermfg=white

    " #include
    hi PreProc ctermfg=darkcyan
    hi Statement ctermfg=darkcyan
    hi Constant ctermfg=red
    " int, void
    hi Type ctermfg=darkcyan
    hi Special ctermfg=lightblue

    hi Search ctermbg=darkgreen
    hi Search ctermfg=white

    " netrw
    hi MKExe ctermfg=lightgreen
    hi Directory ctermfg=lightblue
    hi link netrwExe MKExe
else
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
    hi MKExe guifg=lightgreen
    hi Directory guifg=#79C0FF gui=bold
    hi link netrwExe MKExe
endif


" ------------ for coding ------------
augroup coding_group
    autocmd!
    autocmd FileType python,tcl,sh setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType vim setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType netrw set statusline=%F
    autocmd FileType * call <SID>SetStatusLine()
    autocmd BufWritePost *.vimrc source %
    autocmd BufWritePre .py,.sh,.tcl silent! :%s/\v\s+$//g
    " it is not a good event. However, I can't find the right event now.
    " only windos gvim needs.
    autocmd Vimresized * call <SID>BackToNetrwWindow()
augroup END

" for tmux
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif


" ------------ functions  ------------
function! <SID>OpenModuleFile()
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

function! <SID>SetColorColumn()
    let l:cursor = getpos(".")
    execute ":set colorcolumn=" . l:cursor[2]
endfunction

function! <SID>GetCurrNetrwFile()
    let l:s = expand("%:p") . getline(".")
    return l:s
endfunction

function! <SID>SetStatusLine()
    if &ft != "netrw"
        execute ":set statusline=%F\\ %=%y[Col:%v][Row:%l/%L]"
    endif
endfunction
execute <SID>SetStatusLine()

function! <SID>GetWinWidth()
    if s:MK_set_winwidth == 1
        return
    endif

    let s:MK_set_winwidth = 1

    let l:count = winnr("$")
    let l:n = 0
    let l:i = 0
    while l:i < l:count
        let l:n += winwidth(l:i)
        let l:i += 1
    endwhile

    if l:n > 0
        let s:MK_winwidth = float2nr(l:n * 0.75)
    endif
endfunction

function! <SID>OpenFileToRight(curr_file)
    if s:MK_set_winwidth == 0
        call <SID>GetWinWidth()
    endif
    
    let s:MK_sv = winsaveview()
    
    execute ":vsplit " . a:curr_file
    execute ":normal! " . s:MK_winwidth . "\<C-W>|\<CR>"
endfunction

function! <SID>BackToNetrwWindow()
    if !exists('s:MK_sv') || has('unix')
        return
    endif
    
    let s:MK_restore_count += 1
    call winrestview(s:MK_sv)

    if s:MK_restore_count == 2
        unlet s:MK_sv
        let s:MK_restore_count = 0
    endif
endfunction

