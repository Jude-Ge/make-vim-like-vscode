" =============================================================================
" VS Code-like Vim configuration -- one file, no third-party plugins required.
" Target: Vim 8.0+ in a UTF-8 Linux terminal (graceful fallbacks are included).
"
" FEATURE SWITCHES
" Keep a line uncommented to enable that feature; add a leading " to disable it.
" =============================================================================
let g:vscode_theme               = 1  " VS Code Dark+ inspired colors
let g:vscode_line_ui             = 1  " line numbers, cursor line, guide column
let g:vscode_statusline          = 1  " built-in VS Code-like status line
let g:vscode_mouse               = 1  " mouse selection, scrolling and resizing
let g:vscode_file_explorer       = 1  " Ctrl-B / <Space>e: built-in netrw explorer
let g:vscode_file_finder         = 1  " Ctrl-P / <Space>ff: project file prompt
let g:vscode_project_search      = 1  " <Space>fg: project-wide text search
let g:vscode_comments            = 1  " Ctrl-/ or <Space>/: toggle comments
let g:vscode_auto_pairs          = 1  " automatically close brackets and quotes
let g:vscode_hdl_dictionary      = 1  " Tab completion for VHDL/Verilog/SystemVerilog
let g:vscode_folding             = 1  " indentation/syntax folding shortcuts
let g:vscode_terminal            = 1  " <Space>tt: built-in terminal when available
let g:vscode_persistent_undo     = 1  " undo history survives Vim restarts
let g:vscode_system_clipboard    = 1  " <Space>y/p when Vim has +clipboard
" let g:vscode_ctrl_clipboard   = 1  " OPTIONAL: Ctrl-C/X/V; may conflict with terminal
" let g:vscode_trim_on_save     = 1  " OPTIONAL: remove trailing spaces when saving

" -----------------------------------------------------------------------------
" Foundation
" -----------------------------------------------------------------------------
scriptencoding utf-8
let s:vimrc_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
set nocompatible
set encoding=utf-8
set hidden
set autoread
set confirm
set updatetime=300
set timeoutlen=500
set ttimeoutlen=50
set history=1000
set backspace=indent,eol,start
set virtualedit=block
set selection=inclusive
set switchbuf=useopen,usetab,newtab
set nrformats-=octal
set modelines=0
set nomodeline

" Search like VS Code: ignore case until an uppercase letter is entered.
set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" Indentation and display defaults. FileType rules below refine these values.
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set autoindent
set smartindent
set breakindent
set linebreak
set nowrap
set scrolloff=5
set sidescrolloff=5
set list
set listchars=tab:»·,trail:·,extends:›,precedes:‹,nbsp:␣

" Completion menus use words from open buffers, included files and tags.
set complete=.,w,b,u,t,i
set completeopt=menuone,noselect
set shortmess+=c
set wildmenu
set wildmode=longest:full,full
set wildignorecase
set path=.,**
set suffixesadd=.c,.h,.cpp,.hpp,.py,.js,.ts,.json,.sh,.md
set wildignore+=*/.git/*,*/.svn/*,*/node_modules/*,*/dist/*,*/build/*
set wildignore+=*.o,*.obj,*.pyc,*.class,*.jar,*.zip,*.png,*.jpg,*.gif,*.pdf

syntax enable
filetype plugin indent on

let mapleader = "\<Space>"
let maplocalleader = ","

" -----------------------------------------------------------------------------
" VS Code Dark+ inspired theme (GUI/true-color plus 256-color fallback)
" -----------------------------------------------------------------------------
function! s:ApplyVSCodeTheme() abort
  set background=dark
  highlight Normal         guifg=#D4D4D4 guibg=#1E1E1E ctermfg=252 ctermbg=234
  highlight NormalNC       guifg=#CCCCCC guibg=#1E1E1E ctermfg=251 ctermbg=234
  highlight Cursor         guifg=#1E1E1E guibg=#AEAFAD ctermfg=234 ctermbg=248
  highlight CursorLine     guibg=#2A2D2E ctermbg=236 cterm=NONE gui=NONE
  highlight CursorColumn   guibg=#2A2D2E ctermbg=236
  highlight ColorColumn    guibg=#2A2D2E ctermbg=236
  highlight LineNr         guifg=#858585 guibg=#1E1E1E ctermfg=245 ctermbg=234
  highlight CursorLineNr   guifg=#C6C6C6 guibg=#2A2D2E ctermfg=251 ctermbg=236 gui=bold cterm=bold
  highlight SignColumn     guifg=#858585 guibg=#1E1E1E ctermfg=245 ctermbg=234
  highlight VertSplit      guifg=#3F3F46 guibg=#1E1E1E ctermfg=238 ctermbg=234
  highlight WinSeparator   guifg=#3F3F46 guibg=#1E1E1E ctermfg=238 ctermbg=234
  highlight Visual         guibg=#264F78 ctermbg=24
  highlight Search         guifg=#FFFFFF guibg=#613214 ctermfg=231 ctermbg=94
  highlight IncSearch      guifg=#FFFFFF guibg=#515C6A ctermfg=231 ctermbg=240
  highlight MatchParen     guifg=#FFFFFF guibg=#3B514D ctermfg=231 ctermbg=239 gui=bold cterm=bold
  highlight Pmenu          guifg=#D4D4D4 guibg=#252526 ctermfg=252 ctermbg=235
  highlight PmenuSel       guifg=#FFFFFF guibg=#094771 ctermfg=231 ctermbg=24
  highlight PmenuSbar      guibg=#333333 ctermbg=236
  highlight PmenuThumb     guibg=#797979 ctermbg=243
  highlight StatusLine     guifg=#FFFFFF guibg=#007ACC ctermfg=231 ctermbg=32 gui=NONE cterm=NONE
  highlight StatusLineNC   guifg=#CCCCCC guibg=#3C3C3C ctermfg=251 ctermbg=237 gui=NONE cterm=NONE
  highlight TabLine        guifg=#969696 guibg=#2D2D2D ctermfg=246 ctermbg=236
  highlight TabLineSel     guifg=#FFFFFF guibg=#1E1E1E ctermfg=231 ctermbg=234 gui=bold cterm=bold
  highlight TabLineFill    guibg=#252526 ctermbg=235
  highlight Folded         guifg=#808080 guibg=#252526 ctermfg=244 ctermbg=235
  highlight FoldColumn     guifg=#808080 guibg=#1E1E1E ctermfg=244 ctermbg=234
  highlight NonText        guifg=#3B3B3B guibg=#1E1E1E ctermfg=237 ctermbg=234
  highlight SpecialKey     guifg=#404040 guibg=#1E1E1E ctermfg=238 ctermbg=234
  highlight Directory      guifg=#4EC9B0 ctermfg=80
  highlight ErrorMsg       guifg=#F44747 guibg=#1E1E1E ctermfg=203 ctermbg=234
  highlight WarningMsg     guifg=#CCA700 guibg=#1E1E1E ctermfg=178 ctermbg=234
  highlight DiffAdd        guibg=#1E3A2B ctermbg=22
  highlight DiffChange     guibg=#1C3B57 ctermbg=23
  highlight DiffDelete     guifg=#F44747 guibg=#3A1D1D ctermfg=203 ctermbg=52
  highlight DiffText       guibg=#264F78 ctermbg=24 gui=bold cterm=bold

  " Syntax palette based on VS Code's default Dark+ theme.
  highlight Comment        guifg=#6A9955 ctermfg=65 gui=italic cterm=NONE
  highlight Constant       guifg=#4FC1FF ctermfg=81
  highlight String         guifg=#CE9178 ctermfg=173
  highlight Character      guifg=#CE9178 ctermfg=173
  highlight Number         guifg=#B5CEA8 ctermfg=151
  highlight Boolean        guifg=#569CD6 ctermfg=75
  highlight Float          guifg=#B5CEA8 ctermfg=151
  highlight Identifier     guifg=#9CDCFE ctermfg=117
  highlight Function       guifg=#DCDCAA ctermfg=187
  highlight Statement      guifg=#C586C0 ctermfg=176
  highlight Conditional    guifg=#C586C0 ctermfg=176
  highlight Repeat         guifg=#C586C0 ctermfg=176
  highlight Label          guifg=#C586C0 ctermfg=176
  highlight Operator       guifg=#D4D4D4 ctermfg=252
  highlight Keyword        guifg=#569CD6 ctermfg=75
  highlight Exception      guifg=#C586C0 ctermfg=176
  highlight PreProc        guifg=#C586C0 ctermfg=176
  highlight Include        guifg=#C586C0 ctermfg=176
  highlight Type           guifg=#4EC9B0 ctermfg=80
  highlight StorageClass   guifg=#569CD6 ctermfg=75
  highlight Structure      guifg=#4EC9B0 ctermfg=80
  highlight Typedef        guifg=#4EC9B0 ctermfg=80
  highlight Special        guifg=#D7BA7D ctermfg=180
  highlight Underlined     guifg=#3794FF ctermfg=69 gui=underline cterm=underline
  highlight Todo           guifg=#1E1E1E guibg=#CCA700 ctermfg=234 ctermbg=178 gui=bold cterm=bold
endfunction

if exists('g:vscode_theme')
  if exists('+termguicolors') && has('gui_running')
    set termguicolors
  elseif exists('+termguicolors') && !has('win32') && ($COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit')
    set termguicolors
  endif
  silent! colorscheme default
  call s:ApplyVSCodeTheme()
  augroup vscode_theme
    autocmd!
    autocmd ColorScheme * call <SID>ApplyVSCodeTheme()
  augroup END
  command! VSCodeTheme call <SID>ApplyVSCodeTheme()
endif

" -----------------------------------------------------------------------------
" Editor chrome and status bar
" -----------------------------------------------------------------------------
if exists('g:vscode_line_ui')
  set number
  set relativenumber
  set cursorline
  set colorcolumn=80
  set ruler
  set showcmd
  set showmatch
  set matchtime=2
  if exists('+signcolumn')
    set signcolumn=yes
  endif
  nnoremap <silent> <F3> :set invrelativenumber<CR>
  nnoremap <silent> <F4> :set invlist<CR>
endif

function! s:StatusFile() abort
  let l:name = expand('%:~:.')
  return empty(l:name) ? '[Untitled]' : l:name
endfunction

function! s:ModeLabel() abort
  let l:mode = mode(1)
  if l:mode =~# '^no'
    return 'OPERATOR'
  elseif l:mode ==# 'v'
    return 'VISUAL'
  elseif l:mode ==# 'V'
    return 'V-LINE'
  elseif l:mode ==# "\<C-v>"
    return 'V-BLOCK'
  elseif l:mode =~# '^[sS]'
    return 'SELECT'
  elseif l:mode =~# '^i'
    return 'INSERT'
  elseif l:mode =~# '^R'
    return 'REPLACE'
  elseif l:mode =~# '^c'
    return 'COMMAND'
  elseif l:mode =~# '^t'
    return 'TERMINAL'
  endif
  return 'NORMAL'
endfunction

if exists('g:vscode_statusline')
  set laststatus=2
  set noshowmode
  let &statusline = ' %{' . expand('<SID>') . 'ModeLabel()}  %{' . expand('<SID>') . 'StatusFile()}%m%r%h%w'
        \ . '%='
        \ . '%{&filetype ==# "" ? "plain text" : &filetype}  '
        \ . '%{&fileencoding ==# "" ? &encoding : &fileencoding}  '
        \ . '%{&fileformat}  %l:%c  %p%% '
endif

if exists('g:vscode_mouse') && has('mouse')
  set mouse=a
endif

" -----------------------------------------------------------------------------
" VS Code-like editing and navigation
" -----------------------------------------------------------------------------
nnoremap <silent> <C-s> :update<CR>
inoremap <silent> <C-s> <C-O>:update<CR>
vnoremap <silent> <C-s> <C-C>:update<CR>gv
nnoremap <silent> <C-n> :enew<CR>
nnoremap <silent> <leader>w :update<CR>
nnoremap <silent> <leader>q :confirm quit<CR>

" Keep the selection after indenting, just like VS Code.
vnoremap < <gv
vnoremap > >gv
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Move selected lines with Alt-Up / Alt-Down (terminal support varies).
nnoremap <silent> <M-Up> :move-2<CR>==
nnoremap <silent> <M-Down> :move+<CR>==
inoremap <silent> <M-Up> <C-O>:move-2<CR><C-O>==
inoremap <silent> <M-Down> <C-O>:move+<CR><C-O>==
vnoremap <silent> <M-Up> :move '<-2<CR>gv=gv
vnoremap <silent> <M-Down> :move '>+1<CR>gv=gv

" Window navigation and resizing.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> <M-h> :vertical resize -2<CR>
nnoremap <silent> <M-l> :vertical resize +2<CR>
nnoremap <silent> <M-j> :resize -1<CR>
nnoremap <silent> <M-k> :resize +1<CR>
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>
nnoremap <leader>so <C-w>o

" Buffers behave like VS Code editor tabs.
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> <C-PageUp> :bprevious<CR>
nnoremap <silent> <C-PageDown> :bnext<CR>
nnoremap <silent> <leader>bb :buffers<CR>:buffer<Space>
nnoremap <silent> <leader>bd :confirm bdelete<CR>

function! s:OnlyCurrentBuffer() abort
  let l:current = bufnr('%')
  let l:modified = []
  for l:bufnr in range(1, bufnr('$'))
    if l:bufnr == l:current || !buflisted(l:bufnr)
      continue
    endif
    if getbufvar(l:bufnr, '&modified')
      call add(l:modified, empty(bufname(l:bufnr)) ? '[Untitled]' : fnamemodify(bufname(l:bufnr), ':t'))
    else
      silent execute 'bdelete ' . l:bufnr
    endif
  endfor
  if !empty(l:modified)
    echohl WarningMsg
    echo 'Kept modified buffers: ' . join(l:modified, ', ')
    echohl None
  endif
endfunction

nnoremap <silent> <leader>bo :call <SID>OnlyCurrentBuffer()<CR>
command! VSCodeOnlyBuffer call <SID>OnlyCurrentBuffer()

" Familiar editor actions.
nnoremap <silent> <F2> :let @/=expand('<cword>')<Bar>set hlsearch<CR>cgn
nnoremap <silent> gd gd
nnoremap <silent> <leader>rn :let @/=expand('<cword>')<Bar>set hlsearch<CR>cgn

function! s:SmartTab() abort
  if pumvisible()
    return "\<C-n>"
  endif
  let l:before_cursor = strpart(getline('.'), 0, col('.') - 1)
  if get(b:, 'vscode_dictionary_completion', 0) && l:before_cursor =~# '\k$'
    return "\<C-x>\<C-k>\<C-n>"
  endif
  return "\<Tab>"
endfunction

inoremap <expr> <Tab> <SID>SmartTab()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-d>"
inoremap <C-Space> <C-n>

" -----------------------------------------------------------------------------
" Built-in file explorer (netrw)
" -----------------------------------------------------------------------------
function! s:ToggleExplorer() abort
  for l:winnr in range(1, winnr('$'))
    if getbufvar(winbufnr(l:winnr), '&filetype') ==# 'netrw'
      execute l:winnr . 'wincmd c'
      return
    endif
  endfor
  " New netrw versions inspect mappings and define unique Ctrl-H/Ctrl-L keys.
  " Temporarily remove our window mappings while netrw builds its buffer maps.
  silent! nunmap <C-h>
  silent! nunmap <C-j>
  silent! nunmap <C-k>
  silent! nunmap <C-l>
  try
    if exists(':Lexplore') == 2
      execute 'Lexplore ' . fnameescape(getcwd())
    elseif exists(':Explore') == 2
      Explore
    else
      echohl WarningMsg | echo 'netrw is not available in this Vim build' | echohl None
    endif
  finally
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l
  endtry
endfunction

if exists('g:vscode_file_explorer')
  let g:netrw_banner = 0
  let g:netrw_liststyle = 3
  let g:netrw_browse_split = 4
  let g:netrw_altv = 1
  let g:netrw_winsize = 25
  let g:netrw_keepdir = 0
  nnoremap <silent> <C-b> :call <SID>ToggleExplorer()<CR>
  nnoremap <silent> <leader>e :call <SID>ToggleExplorer()<CR>
  command! VSCodeExplorer call <SID>ToggleExplorer()
endif

" -----------------------------------------------------------------------------
" Go to File and project-wide search, implemented entirely in Vimscript
" -----------------------------------------------------------------------------
let s:file_cache_root = ''
let s:file_cache = []

function! s:IsProjectFile(path) abort
  let l:path = substitute(a:path, '\\', '/', 'g')
  if !filereadable(a:path)
    return 0
  endif
  if l:path =~# '/\%(.git\|.svn\|node_modules\|dist\|build\)/'
    return 0
  endif
  return l:path !~# '\.\%(o\|obj\|pyc\|class\|jar\|zip\|png\|jpe\?g\|gif\|pdf\)$'
endfunction

function! s:ProjectFiles(refresh) abort
  let l:root = getcwd()
  if a:refresh || s:file_cache_root !=# l:root
    let s:file_cache_root = l:root
    let s:file_cache = []
    let l:candidates = globpath('.', '**/*', 0, 1)
          \ + globpath('.', '.*', 0, 1)
          \ + globpath('.', '.github/**/*', 0, 1)
    for l:path in l:candidates
      if s:IsProjectFile(l:path)
        call add(s:file_cache, substitute(substitute(l:path, '\\', '/', 'g'), '^\./', '', ''))
      endif
    endfor
    call sort(s:file_cache)
    call uniq(s:file_cache)
  endif
  return copy(s:file_cache)
endfunction

function! s:FuzzyPattern(query) abort
  let l:pattern = ''
  for l:char in split(a:query, '\zs')
    let l:pattern .= (empty(l:pattern) ? '' : '.\{-}') . escape(l:char, '\.^$~[]*')
  endfor
  return l:pattern
endfunction

function! s:FindFile() abort
  let l:query = input('Go to File: ')
  if empty(l:query)
    return
  endif
  let l:pattern = s:FuzzyPattern(l:query)
  let l:matches = filter(s:ProjectFiles(0), 'v:val =~? l:pattern')
  if empty(l:matches)
    echohl WarningMsg | echo 'No matching project file: ' . l:query | echohl None
    return
  endif
  if len(l:matches) == 1
    execute 'edit ' . fnameescape(l:matches[0])
    return
  endif

  let l:shown = l:matches[0 : min([len(l:matches), 20]) - 1]
  let l:choices = ['Go to File (select a number):']
  for l:index in range(0, len(l:shown) - 1)
    call add(l:choices, printf('%2d. %s', l:index + 1, l:shown[l:index]))
  endfor
  if len(l:matches) > len(l:shown)
    call add(l:choices, printf('... %d more; use a narrower query', len(l:matches) - len(l:shown)))
  endif
  let l:choice = inputlist(l:choices)
  if l:choice >= 1 && l:choice <= len(l:shown)
    execute 'edit ' . fnameescape(l:shown[l:choice - 1])
  endif
endfunction

function! s:RefreshProjectFiles() abort
  let l:count = len(s:ProjectFiles(1))
  echo printf('Project file cache refreshed: %d files', l:count)
endfunction

if exists('g:vscode_file_finder')
  nnoremap <silent> <C-p> :call <SID>FindFile()<CR>
  nnoremap <silent> <leader>ff :call <SID>FindFile()<CR>
  command! VSCodeFind call <SID>FindFile()
  command! VSCodeFilesRefresh call <SID>RefreshProjectFiles()
endif

function! s:RunProjectSearch(text) abort
  if empty(a:text)
    return
  endif
  let l:pattern = '\V' . escape(a:text, '/\\')
  let @/ = l:pattern
  let l:files = filter(s:ProjectFiles(0), 'filereadable(v:val)')
  call setqflist([], 'r')
  if empty(l:files)
    echohl WarningMsg | echo 'No searchable files under: ' . getcwd() | echohl None
    return
  endif

  " Keep each command short enough for conservative shells and old Vim builds.
  for l:start in range(0, len(l:files) - 1, 40)
    let l:batch = l:files[l:start : min([l:start + 39, len(l:files) - 1])]
    try
      silent execute 'vimgrepadd /' . l:pattern . '/gj ' . join(map(copy(l:batch), 'fnameescape(v:val)'))
    catch /^Vim\%((\a\+)\)\=:E480/
      " A batch without matches is normal; continue with the remaining files.
    endtry
  endfor

  if empty(getqflist())
    echohl WarningMsg | echo 'No matches: ' . a:text | echohl None
  else
    copen
  endif
endfunction

function! s:ProjectSearch() abort
  call s:RunProjectSearch(input('Search project: ', expand('<cword>')))
endfunction

function! s:SearchWordUnderCursor() abort
  call s:RunProjectSearch(expand('<cword>'))
endfunction

if exists('g:vscode_project_search')
  nnoremap <silent> <leader>fg :call <SID>ProjectSearch()<CR>
  nnoremap <silent> <F7> :copen<CR>
  nnoremap <silent> [q :cprevious<CR>
  nnoremap <silent> ]q :cnext<CR>
  nnoremap <silent> gr :call <SID>SearchWordUnderCursor()<CR>
  command! VSCodeSearch call <SID>ProjectSearch()
  command! VSCodeSearchWord call <SID>SearchWordUnderCursor()
endif

" -----------------------------------------------------------------------------
" Ctrl-/ comment toggling for common languages
" -----------------------------------------------------------------------------
function! s:ToggleComment(first, last) abort
  let l:marker = get(b:, 'vscode_comment_marker', '#')
  let l:end_marker = get(b:, 'vscode_comment_end', '')
  let l:escaped = escape(l:marker, '\.*$^~[]/')
  let l:end_escaped = escape(l:end_marker, '\.*$^~[]/')
  let l:all_commented = 1

  for l:lnum in range(a:first, a:last)
    let l:text = getline(l:lnum)
    if l:text !~# '^\s*$' && l:text !~# '^\s*' . l:escaped
      let l:all_commented = 0
      break
    endif
  endfor

  for l:lnum in range(a:first, a:last)
    let l:text = getline(l:lnum)
    if l:text =~# '^\s*$'
      continue
    endif
    if l:all_commented
      let l:uncommented = substitute(l:text, '^\(\s*\)' . l:escaped . '\s\?', '\1', '')
      if !empty(l:end_marker)
        let l:uncommented = substitute(l:uncommented, '\s\?' . l:end_escaped . '\s*$', '', '')
      endif
      call setline(l:lnum, l:uncommented)
    else
      let l:indent = matchstr(l:text, '^\s*')
      let l:body = substitute(l:text, '^\s*', '', '')
      let l:suffix = empty(l:end_marker) ? '' : ' ' . l:end_marker
      call setline(l:lnum, l:indent . l:marker . ' ' . l:body . l:suffix)
    endif
  endfor
endfunction

if exists('g:vscode_comments')
  augroup vscode_comment_markers
    autocmd!
    autocmd FileType * unlet! b:vscode_comment_marker b:vscode_comment_end
    autocmd FileType c,cpp,cs,java,javascript,javascriptreact,typescript,typescriptreact,go,rust,swift,kotlin,scala,verilog,systemverilog let b:vscode_comment_marker = '//'
    autocmd FileType python,ruby,perl,sh,bash,zsh,fish,yaml,toml,make,dockerfile,conf let b:vscode_comment_marker = '#'
    autocmd FileType vim let b:vscode_comment_marker = '"'
    autocmd FileType lua,sql,haskell,vhdl let b:vscode_comment_marker = '--'
    autocmd FileType html,xml let b:vscode_comment_marker = '<!--'
    autocmd FileType html,xml let b:vscode_comment_end = '-->'
    autocmd FileType css,scss,less let b:vscode_comment_marker = '/*'
    autocmd FileType css,scss,less let b:vscode_comment_end = '*/'
    autocmd FileType tex let b:vscode_comment_marker = '%'
  augroup END
  command! -range VSCodeComment call <SID>ToggleComment(<line1>, <line2>)
  nnoremap <silent> <C-_> :VSCodeComment<CR>
  vnoremap <silent> <C-_> :<C-U>execute "'<,'>VSCodeComment"<CR>gv
  nnoremap <silent> <leader>/ :VSCodeComment<CR>
  vnoremap <silent> <leader>/ :<C-U>execute "'<,'>VSCodeComment"<CR>gv
endif

" -----------------------------------------------------------------------------
" Lightweight automatic pairs
" -----------------------------------------------------------------------------
function! s:ClosePair(char) abort
  return getline('.')[col('.') - 1] ==# a:char ? "\<Right>" : a:char
endfunction

function! s:PairQuote(char) abort
  let l:line = getline('.')
  let l:next = strpart(l:line, col('.') - 1, 1)
  let l:prev = col('.') > 1 ? strpart(l:line, col('.') - 2, 1) : ''
  if l:next ==# a:char
    return "\<Right>"
  endif
  if a:char ==# "'" && l:prev =~# '\k'
    return a:char
  endif
  return a:char . a:char . "\<Left>"
endfunction

function! s:PairBackspace() abort
  let l:line = getline('.')
  let l:prev = col('.') > 1 ? strpart(l:line, col('.') - 2, 1) : ''
  let l:next = strpart(l:line, col('.') - 1, 1)
  return (l:prev . l:next) =~# '^\%(()\|\[\]\|{}\|""\|''''\)$' ? "\<BS>\<Del>" : "\<BS>"
endfunction

if exists('g:vscode_auto_pairs')
  inoremap ( ()<Left>
  inoremap [ []<Left>
  inoremap { {}<Left>
  inoremap <expr> ) <SID>ClosePair(')')
  inoremap <expr> ] <SID>ClosePair(']')
  inoremap <expr> } <SID>ClosePair('}')
  inoremap <expr> " <SID>PairQuote('"')
  inoremap <expr> ' <SID>PairQuote("'")
  inoremap <expr> <BS> <SID>PairBackspace()
endif

" -----------------------------------------------------------------------------
" Folding, terminal, undo and clipboard
" -----------------------------------------------------------------------------
if exists('g:vscode_folding')
  set foldmethod=indent
  set foldlevelstart=99
  set foldnestmax=10
  nnoremap <silent> <leader>z za
  nnoremap <silent> <leader>za zM
  nnoremap <silent> <leader>zr zR
endif

function! s:OpenTerminal() abort
  if exists(':terminal') != 2
    echohl WarningMsg | echo 'This Vim was built without +terminal' | echohl None
    return
  endif
  botright 12new
  execute 'terminal ++curwin ' . (&shell ==# '' ? 'sh' : &shell)
endfunction

if exists('g:vscode_terminal')
  nnoremap <silent> <leader>tt :call <SID>OpenTerminal()<CR>
  command! VSCodeTerminal call <SID>OpenTerminal()
  if has('terminal')
    tnoremap <Esc><Esc> <C-W>N
    tnoremap <C-h> <C-W>h
    tnoremap <C-j> <C-W>j
    tnoremap <C-k> <C-W>k
    tnoremap <C-l> <C-W>l
  endif
endif

if exists('g:vscode_persistent_undo') && has('persistent_undo')
  let s:undo_dir = has('win32') ? expand('~/vimfiles/undo') : expand('~/.vim/undo')
  if !isdirectory(s:undo_dir)
    silent! call mkdir(s:undo_dir, 'p')
  endif
  if isdirectory(s:undo_dir)
    set undofile
    let s:undo_entry = s:undo_dir . '//'
    if index(split(&undodir, ','), s:undo_entry) < 0
      let &undodir = s:undo_entry . ',' . &undodir
    endif
  endif
endif

if exists('g:vscode_system_clipboard') && has('clipboard')
  vnoremap <leader>y "+y
  nnoremap <leader>y "+y
  nnoremap <leader>Y "+y$
  nnoremap <leader>p "+p
  vnoremap <leader>p "+p
endif

if exists('g:vscode_ctrl_clipboard')
  vnoremap <C-c> y
  vnoremap <C-x> d
  nnoremap <C-v> p
  inoremap <C-v> <C-r>"
  cnoremap <C-v> <C-r>"
endif

" -----------------------------------------------------------------------------
" File-type refinements and optional save hooks
" -----------------------------------------------------------------------------
function! s:FindDictionary(filename) abort
  let l:directories = [
        \ s:vimrc_dir . '/dict',
        \ expand('~/.vim/dict'),
        \ expand('~/vimfiles/dict')
        \ ]
  for l:directory in l:directories
    let l:path = simplify(l:directory . '/' . a:filename)
    if filereadable(l:path)
      return l:path
    endif
  endfor
  return ''
endfunction

function! s:EnableHDLDictionary(filename) abort
  let l:path = s:FindDictionary(a:filename)
  if empty(l:path)
    let b:vscode_dictionary_completion = 0
    return
  endif
  if index(split(&l:dictionary, ','), l:path) < 0
    let &l:dictionary = empty(&l:dictionary) ? l:path : l:path . ',' . &l:dictionary
  endif
  if index(split(&l:complete, ','), 'k') < 0
    setlocal complete+=k
  endif
  let b:vscode_dictionary_completion = 1
  let b:vscode_dictionary_path = l:path
endfunction

if exists('g:vscode_hdl_dictionary')
  augroup vscode_hdl_dictionary
    autocmd!
    autocmd BufRead,BufNewFile *.vhd,*.vhdl,*.vho,*.VHD,*.VHDL,*.VHO setfiletype vhdl
    autocmd BufRead,BufNewFile *.v,*.vh,*.V,*.VH setfiletype verilog
    autocmd BufRead,BufNewFile *.sv,*.svh,*.SV,*.SVH setfiletype systemverilog
    autocmd FileType vhdl call <SID>EnableHDLDictionary('vhdl.dict')
    autocmd FileType verilog call <SID>EnableHDLDictionary('verilog.dict')
    autocmd FileType systemverilog call <SID>EnableHDLDictionary('systemverilog.dict')
  augroup END
endif

augroup vscode_filetypes
  autocmd!
  autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact,json,jsonc,html,css,scss,yaml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType c,cpp,cs,java,go,rust,sh,bash,zsh,lua,vim setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType vhdl,verilog,systemverilog setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType make setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=0
  autocmd FileType markdown,text setlocal wrap linebreak
  autocmd FileType netrw setlocal relativenumber
  " Work around netrw's silent E31 when global mappings contain w/b keys.
  autocmd FileType netrw nnoremap <buffer> w w
  autocmd FileType netrw nnoremap <buffer> b b
augroup END

if exists('g:vscode_trim_on_save')
  function! s:TrimTrailingWhitespace() abort
    let l:view = winsaveview()
    silent! keepjumps keeppatterns %s/\s\+$//e
    call winrestview(l:view)
  endfunction
  augroup vscode_trim_whitespace
    autocmd!
    autocmd BufWritePre * call <SID>TrimTrailingWhitespace()
  augroup END
endif

" Show a compact shortcut reminder with :VSCodeHelp.
command! VSCodeHelp echo join([
      \ 'Ctrl-S save | Ctrl-P file | Ctrl-B explorer | Ctrl-N new buffer',
      \ 'Space ff file | Space fg search | Space / comment | Space tt terminal',
      \ '[b/]b buffers | [q/]q results | Ctrl-h/j/k/l windows | F3 relative numbers',
      \ 'HDL: type a keyword prefix, then Tab/Shift-Tab to complete'
      \ ], "\n")
