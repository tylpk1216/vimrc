" ------------ global variables ------------
let g:netrw_keepdir = 0
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_browse_split = 3
set guioptions-=L

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
nnoremap <leader>mo <S-v>/endmodule<CR>y :call <SID>OpenModuleFile()<CR>
nnoremap <leader>cc :call <SID>SetColorColumn()<CR>
nnoremap <leader>dc :set colorcolumn=0<CR>
nnoremap <leader>fm :Vex<CR>
nnoremap <leader>o :call <SID>OpenFileToRight(<SID>GetCurrNetrwFile())<CR>
nnoremap <leader>h gT
nnoremap <leader>l gt
nnoremap nn nzt

" ------------ displaying ------------
syntax on
set hlsearch
colorscheme desert

if has("unix")
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
if has("unix") && !has("win32unix")
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

    hi TabLineSet guifg=red

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
    autocmd FileType go setlocal shiftwidth=4 softtabstop=4
    "autocmd FileType netrw set statusline=%F
    autocmd FileType * call s:SetStatusLine()
    autocmd BufWritePost *.vimrc source %
    autocmd BufWritePre .py,.sh,.tcl,.go silent! :%s/\v\s+$//g
    " it is not a good event. However, I can't find the right event now.
    " only windows gvim needs it.
    autocmd Vimresized * call s:BackToNetrwWindow()
    "autocmd BufEnter * call s:MK_Browse("")
augroup END

" for tmux
if exists("+termguicolors")
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

    if filereadable(l:fname . ".v") == 1
        let l:fname = l:fname . "_"
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

function! s:SetStatusLine()
    if &ft != "netrw"
        execute ":set statusline=%f\\ %=%y[Col:%v][Row:%l/%L]"
    endif
endfunction
execute s:SetStatusLine()

function! s:GetWinWidth()
    if has("s:MK_winwidth")
        return
    endif

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
    if !has("s:MK_winwidth")
        call s:GetWinWidth()
    endif
    
    " prevent from opening window many times.
    if !exists("s:MK_sv")
        let s:MK_sv = winsaveview()
    endif
    
    let g:MK_sv = winsaveview()

    execute ":vsplit " . a:curr_file
    execute ":normal! " . s:MK_winwidth . "\<C-W>|\<CR>"
endfunction

function! s:BackToNetrwWindow()
    "echom "BackToNetrwWindow"
    if !exists("s:MK_sv") || has("unix")
        return
    endif
    
    " prevent from opening window many times.
    let l:count = winnr("$")
    if l:count != 1 && l:count != 2
        return
    endif
    
    let s:MK_restore_count += 1
    call winrestview(s:MK_sv)

    if s:MK_restore_count == 2
        unlet s:MK_sv
        let s:MK_restore_count = 0
    endif
endfunction

"autocmd FileType netrw nnoremap :q :q!
"autocmd FileType netrw nnoremap <CR> :call <SID>MK_Enter_Browse(<SID>GetCurrNetrwFile())<CR>

function! <SID>MK_Enter_Browse(name)
    echom a:name
    if isdirectory(a:name)
        let dir = a:name
        if has('win32')
            let dir = substitute(dir, "/", "\\", "")        
        endif
        
        call chdir(dir)
        call s:MK_Browse(dir)
    else
        let g:MK_sv = winsaveview()
        execute ":tabe " . a:name
    endif
endfunction

function! s:MK_Browse(dir)
    let curr = expand("%:p")
    if a:dir != ""
        let curr = a:dir
    endif

    if !isdirectory(curr)
        execute ":set nocursorline"
        return
    endif
    
    if getcwd() != curr
        call chdir(curr)
    endif

    execute ":set filetype=netrw"
    execute ":setlocal nonumber"
    execute ":setlocal nowrap"
    execute ":setlocal cursorline"
    "execute ":setlocal buftype=nofile"
    
    normal! dG

    let f_list = readdir(curr, 1)
    let n = 1

    let files = []
    let folders = []

    call add(folders, "../")
    call add(folders, "./")

    for f in f_list
        if f == ".swp" || f == "_.swp"
            continue
        endif

        let s = f
        if isdirectory(f)
            let s = s . "/"
            call add(folders, s)
        else
            call add(files, s)
        endif
    endfor

    for f in folders
        call setline(n, f)
        let n = n + 1
    endfor
    
    for f in files
        call setline(n, f)
        let n = n + 1
    endfor

    if exists("g:MK_sv")
        call winrestview(g:MK_sv)
        "unlet g:MK_sv
    endif
endfunction
