" ------------ tmp test ------------
if has("win32")
    "set shell=C:\\Program\ Files\\Git\\bin\\bash.exe
endif


" ------------ global variables ------------
" for netrw
" use it to disable netrw
if has("win32") || has("win32unix")
    let g:loaded_netrwPlugin = 1
endif
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
"set foldmethod=indent
"set mouse=a


" ------------ re-map keys ------------
let mapleader = ","
inoremap jk <esc>
nnoremap t '
" open vimrc to new tab
nnoremap <leader>ev :call <SID>OpenFileToRight($MYVIMRC)<CR>
" next page, previous page
nnoremap <leader>n <C-f>
nnoremap <leader>m <C-b>
nnoremap <leader>sh :set syntax=sh<CR>
" open the file of cursor to new tab
nnoremap <leader>gf <C-w>gf
" open new tab with copied codoe of current module
nnoremap <leader>mo <S-v>/endmodule<CR>y :call <SID>OpenModuleFile(expand("%:p:h"))<CR>
" save previous file of module code
nnoremap <leader>wmo :set buftype=""<CR><Bar>:w<CR><Bar>:call <SID>DumpModulePort()<CR>
" open current file of treeview to new tab
nnoremap <leader>o :call <SID>OpenFileToRight(<SID>GetCurrNetrwFile())<CR>
" about column
nnoremap <leader>cc :call <SID>SetColorColumn()<CR>
nnoremap <leader>dc :set colorcolumn=0<CR>
" about tab
nnoremap <leader>h gT
nnoremap <leader>l gt
" about foldmethod
nnoremap <leader>fmi :set foldmethod=indent<CR>
nnoremap <leader>fmm :set foldmethod=manual<CR>
nnoremap <leader>of zR
nnoremap <leader>cf zM
" open the file explorer based on the path of current file
nnoremap <leader>fm :call <SID>FileExplorer(expand("%:p:h"))<CR>
" find next and put it on the top of area
nnoremap nn nzt

augroup verilog_function_group
    autocmd!
    " display the module name of variable in verilog file
    autocmd FileType verilog nnoremap <buffer> * *<Bar>:call <SID>FindNextAndShowModuleName("normal k", 1)<CR>
    autocmd FileType verilog nnoremap <buffer> # #<Bar>:call <SID>FindNextAndShowModuleName("normal j", 1)<CR>
    autocmd FileType verilog nnoremap <buffer> / <Bar>:set statusline=%{<SID>EmptyString()}<CR><Bar>:redraw!<CR><Bar>/
    autocmd FileType verilog nnoremap <buffer> ? <Bar>:set statusline=%{<SID>EmptyString()}<CR><Bar>:redraw!<CR><Bar>?
    autocmd FileType verilog nnoremap <buffer> f :call <SID>FindNextAndShowModuleName("normal k", 0)<CR>
    autocmd FileType verilog nnoremap <buffer> ff :call <SID>FindNextAndShowModuleName("normal j", 0)<CR>
augroup END


" ------------ displaying ------------
syntax on
set hlsearch
colorscheme desert

if has("unix")
    set guifont=Monospace\ 14
else
    set termguicolors
    set guifont=Courier_New:h18
endif

" max gui window
augroup displaying
    autocmd!
    autocmd GUIEnter * simalt ~x
augroup END

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
    hi TabLineFill ctermfg=black ctermbg=lightyellow
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
    hi TabLineFill guifg=black guibg=lightyellow
    hi TabLine guifg=black guibg=lightyellow
endif


" ------------ for coding ------------
augroup coding_group
    autocmd!
    autocmd FileType python,tcl,sh setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType vim setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType go setlocal shiftwidth=4 softtabstop=4
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
function! <SID>OpenModuleFile(dir)
    let l:line = substitute(getline("."), "(", " ", "")
    let l:strs = split(l:line)

    let l:fname = "tmp"
    if len(l:strs) >= 2
        let l:fname = strs[1]
    endif
   
    " check file 
    "if filereadable(l:fname . ".v") == 1
    "    let l:fname = l:fname . "_"
    "endif

    let l:fname = a:dir . "/" . l:fname . ".vim.v"

    execute ":tabe " . l:fname
    execute ":setlocal buftype=nowrite"
    normal! p
    execute ":set syntax=verilog"
    execute ":set ft=verilog" 
endfunction

function! <SID>DumpModulePort()
    let l:fname = expand("%:p")

if has("win32")
    let l:script = "D:\\5129\\MKProject\\Source\\WorkCode\\VIA\\MKProject\\DFT\\Coding\\python_netlistparser\\print_module_pin.py"
    if filereadable(l:script) != 1
        return
    endif
    execute ":!python " . l:script . " " . l:fname
endif

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
        execute ":set statusline=%t\\ %=%y[Col:%v][Row:%l/%L][%p%%]"
    else
        execute ":set statusline=[%F]"
    endif
endfunction
execute s:SetStatusLine()

function! s:GetWinWidth()
    if exists("s:MK_winwidth")
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

    if !exists("s:MK_winwidth")
        call s:GetWinWidth()
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
        let bufft = getbufvar(bufnr, "&filetype")
        let showname = (bufft == "netrw" ? "Tree" : "New")

        let s .= "%" . tab . "T"
        let s .= (tab == tabpagenr() ? "%#TabLineSel#" : "%#TabLine#")
        let s .= " (" . tab . ")"
        let s .= (bufname != "" ? bufname : showname)

        if bufmodified
            let s .= "+"
        endif

        let s .= " "
    endfor
    let s .= "%#TabLineFill#%T"
    return s
endfunction
set tabline=%!Tabline()

function! <SID>EmptyString()
    return ""
endfunction

function! GetModuleName()
    let l:s = ""
    if exists("s:ModuleName")
        let l:s = s:ModuleName
    endif
    return l:s
endfunction

function! IsInstanceSyntaxByRegex()
    let l:line = getline(".")
    let l:s = expand("<cword>")
    " example: .A(A)
    let l:pattern = "(.*" . l:s . ".*)"
    return match(l:line, l:pattern)
endfunction

function! IsInstanceSyntaxBySearchString()
    let l:line = getline(".")
    let l:count = 0
    let chars = [".", "(", ")"]
    for char in chars
        if stridx(l:line, char) != -1
            let l:count = l:count + 1
        endif
    endfor

    if l:count == 0
        return -1
    endif
    return 1
endfunction

function! <SID>FindNextAndShowModuleName(littleMoving, isSpecialCase)
    " calling by *, #
    if a:isSpecialCase
        execute a:littleMoving
    endif

    " next
    normal n
    normal mn
    let l:position = winsaveview()
   
    " is in instance syntax?
    let l:inst_name = "no"
    let l:inst_n = -1
    if IsInstanceSyntaxBySearchString() != -1
        execute "normal /;\<CR>|j|^"
        execute "normal ?)\<CR>"
        normal %
        " get instance name
        normal mi
        let l:inst_n = line(".")
        let l:s = getline(".")
        let l:list = matchlist(l:s, '\s*\([a-zA-Z0-9_\\\$\[\]]\+\)\s\+.*')
        if len(l:list) > 2
            let l:inst_name = l:list[1]
            " extra check because IsInstanceSyntaxBySearchString is not good enough now.
            if l:inst_name == "module"
                let l:inst_n = -1
            endif
        endif
        " back to original position
        normal 'n
    endif

    " find module name
    " line is in the line of module name
    if stridx(getline("."), "module ") == -1
        execute "normal ?module \<CR>|:redraw!"
    endif
    normal mm
    
    " get module information
    let l:n = line(".")
    let l:s = getline(".")
    
    let l:list = matchlist(l:s, '\s*module\s\+\([a-zA-Z0-9_\\\$\[\]]\+\).*')
    if len(l:list) > 2
        let s:ModuleName = "Module: " . l:list[1] . " (" . l:n . ")"
    else
        let s:ModuleName = "(" . l:n . ")"
    endif

    "append instacne info
    if l:inst_n != -1
        let s:ModuleName = s:ModuleName . ", instance: " . l:inst_name . " (" . l:inst_n . ")"
    endif
    
    " back to pattern location
    normal 'n
    call winrestview(l:position)
    
    " show information in statusline
    execute ":set statusline=%{GetModuleName()}"
endfunction

function! <SID>FileExplorer(dir)
    execute ":tabe " . a:dir
    execute ":tabm 0"
endfunction


" for my file explorer
augroup explorer_group
    autocmd!
if has("win32") || has("win32unix")
    autocmd BufEnter * call s:MK_Browse()
    autocmd FileType netrw nnoremap <CR> :call <SID>MK_Enter_Browse(<SID>GetCurrNetrwFile())<CR>
    autocmd FileType netrw nnoremap - gg :call <SID>MK_Enter_Browse(<SID>GetCurrNetrwFile())<CR>
    autocmd FileType netrw nnoremap D :call <SID>MK_Delete_Browse_Item(<SID>GetCurrNetrwFile())<CR>
endif
augroup END

function! <SID>MK_Enter_Browse(name)
    let l:i = stridx(a:name, ".lnk")
    if isdirectory(a:name) || l:i != -1
        let l:dir = a:name
        " avoid ..\ or C:\..\ 
        let l:i = stridx(l:dir, "..")
        echom l:dir . l:i
        if l:i == 0 || l:i == 1 || l:i == 3
            execute ":redraw!"
            return
        endif
        execute ":e! " . l:dir
    else
        let l:ok = filereadable(a:name)
        if !ok
            execute ":redraw!"
            return
        endif

        let g:MK_curr = getcwd()
        let g:MK_sv = winsaveview()
        execute ":tabe " . a:name
    endif
endfunction

function! s:MK_Browse()
    " get current directory
    let curr = expand("%:p")

    " not directory, do nothing
    if !isdirectory(curr)
        call s:SetStatusLine()
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

    let curr_buf_id = bufnr("%")
    if exists("g:MK_buf_id") && bufexists(g:MK_buf_id) && g:MK_buf_id != curr_buf_id
        "execute ":" . g:MK_buf_id . "bdelete!"
        execute ":" . g:MK_buf_id . "bwipeout!"
        unlet g:MK_buf_id
    endif
    
    let g:MK_buf_id = curr_buf_id
    
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
