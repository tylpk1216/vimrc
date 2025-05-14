" ------------ global variables ------------
" for netrw
let g:netrw_keepdir = 0
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_browse_split = 3


" ------------ general settings ------------
set tabstop=4
set number
set autoindent
set title
set showcmd
set backspace=indent,eol,start
set splitright
set cmdheight=2
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
nnoremap <leader>mo <S-v>/endmodule<CR>y :call <SID>OpenModuleFile()<CR>
nnoremap <leader>cc :call <SID>SetColorColumn()<CR>
nnoremap <leader>dc :set colorcolumn=0<CR>
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
autocmd GUIEnter * simalt ~x

" status line
set laststatus=2

" no scrollbar no gui tab
set guioptions-=L
set guioptions-=e

" tab line
set showtabline=2

" adjust theme (ctermbg/guibg)
if has("unix") && !has("win32unix") && !has("gui")
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
    
    " tabline
    hi TabLineSel ctermfg=black ctermbg=lightblue cterm=bold
    hi TabLine ctermfg=black ctermbg=lightyellow
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
    
    " tabline
    hi TabLineSel guifg=black guibg=#79C0FF gui=bold
    hi TabLine guifg=black guibg=lightyellow
endif


" ------------ for coding ------------
augroup coding_group
    autocmd!
    autocmd FileType python,tcl,sh setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType vim setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType go setlocal shiftwidth=4 softtabstop=4
    autocmd FileType * call s:SetStatusLine()
    autocmd BufWritePost *.vimrc source %
    autocmd BufWritePre *.py,*.tcl,*.sh :%s/\v\s+$//e
    autocmd BufWritePre *.go :%s/\v\t+$//e
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

    if has('win32')
        let l:s = substitute(l:s, "/", "\\", "")        
    endif

    return l:s
endfunction

function! s:SetStatusLine()
    if &ft != "netrw"
        execute ":set statusline=%f\\ %=%y[Col:%v][Row:%l/%L]"
    else
        execute ":set statusline=[%F]"
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
    if !filereadable(a:curr_file)
        execute ":redraw!"
        return
    endif

    if !has("s:MK_winwidth")
        call s:GetWinWidth()
    endif
    
    " prevent from opening window many times.
    if !exists("s:MK_sv")
        let s:MK_sv = winsaveview()
    endif
    
    let g:MK_curr = getcwd()
    let g:MK_sv = winsaveview()

    execute ":vsplit " . a:curr_file
    execute ":normal! " . s:MK_winwidth . "\<C-W>|\<CR>"
endfunction

function! Tabline()
    let s = ""
    for i in range(tabpagenr("$"))
        let tab = i + 1
        let winnr = tabpagewinnr(tab)
        let buflist = tabpagebuflist(tab)
        let bufnr = buflist[winnr - 1]
        let bufname = fnamemodify(bufname(bufnr), ":t")
        let bufmodified = getbufvar(bufnr, "&mod")

        let s .= "%" . tab . "T"
        let s .= (tab == tabpagenr() ? "%#TabLineSel#" : "%#TabLine#")
        let s .= " (" . tab . ")"
        let s .= (bufname != "" ? bufname : "MKTree")

        if bufmodified
            let s .= "+ "
        endif

        let s .= " "
    endfor
    return s
endfunction
set tabline=%!Tabline()


" for my file explorer
augroup explorer_group
    autocmd!
    autocmd BufEnter * call s:MK_Browse("")
    autocmd FileType netrw nnoremap <CR> :call <SID>MK_Enter_Browse(<SID>GetCurrNetrwFile())<CR>
    autocmd FileType netrw nnoremap - gg :call <SID>MK_Enter_Browse(<SID>GetCurrNetrwFile())<CR>
    autocmd FileType netrw nnoremap D :call <SID>MK_Delete_Browse_Item(<SID>GetCurrNetrwFile())<CR>
    autocmd FileType netrw nnoremap <leader>o :call <SID>OpenFileToRight(<SID>GetCurrNetrwFile())<CR>
    "autocmd FileType netrw nnoremap i <ESC>
    "autocmd FileType netrw nnoremap I <ESC>
    "autocmd FileType netrw nnoremap a <ESC>
    "autocmd FileType netrw nnoremap A <ESC>
    "autocmd FileType netrw nnoremap x <ESC>
    "autocmd FileType netrw nnoremap s <ESC>
    "autocmd FileType netrw nnoremap y <ESC>
    "autocmd FileType netrw nnoremap p <ESC>
augroup END

function! <SID>MK_Enter_Browse(name)
    if isdirectory(a:name)
        let l:dir = a:name
        if has('win32')
            let l:dir = substitute(dir, "/", "\\", "")        
        endif
        
        execute ":e! " . l:dir
    else
        let g:MK_curr = getcwd()
        let g:MK_sv = winsaveview()
        execute ":tabe " . a:name
    endif
endfunction

function! s:MK_Browse(dir)
    " get current directory
    let curr = expand("%:p")
    if a:dir != ""
        let curr = a:dir
    endif

    " not directory, do nothing
    if !isdirectory(curr)
        return
    endif
    
    " change folder for later using
    if getcwd() != curr
        call chdir(curr)
    endif

    " set up some options
    execute ":set filetype=netrw"
    execute ":setlocal nonumber"
    execute ":setlocal nowrap"
    execute ":setlocal cursorline"
    execute ":setlocal buftype=nowrite"
    
    " delete original path structure
    normal! dG

    let f_list = readdir(curr, 1)
    let n = 1

    " save paths
    let files = []
    let folders = []

    call add(folders, "../")
    call add(folders, "./")
    
    for f in f_list
        let i = stridx(f, ".swp")
        if i != -1
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
    
    " add folders
    for f in folders
        call setline(n, f)
        let n = n + 1
    endfor
    
    " add files
    for f in files
        call setline(n, f)
        let n = n + 1
    endfor

    " restore previous position
    if exists("g:MK_sv")
        if g:MK_curr == getcwd()
            call winrestview(g:MK_sv)
            unlet g:MK_sv
        endif
    endif

    " statusline
    call s:SetStatusLine()
endfunction

function! <SID>MK_Delete_Browse_Item(curr)
    let f = fnamemodify(a:curr, ":t")
    let ok = input("Delete " . f . " (yes/no) : ")
    if ok != "yes" && ok != "y"
        execute ":redraw!"
        return
    endif

    let res = delete(a:curr)
    let msg = " failed"
    if res == 0
        let msg = " successfully"
    endif
    echo "Delete " . a:curr . msg
    execute ":e"
endfunction
