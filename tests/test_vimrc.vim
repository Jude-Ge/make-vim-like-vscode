" Headless smoke tests for .vimrc. Run from the repository root.
set nomore

call assert_equal(1, &hidden, 'hidden buffers must be enabled')
call assert_equal(1, &ignorecase, 'ignorecase must be enabled')
call assert_equal(1, &smartcase, 'smartcase must be enabled')
call assert_equal(1, &number, 'absolute line numbers must be enabled')
call assert_equal(1, &relativenumber, 'relative line numbers must be enabled')
call assert_notequal('', maparg('<C-s>', 'n'), 'Ctrl-S mapping is missing')
call assert_notequal('', maparg('<C-p>', 'n'), 'Ctrl-P mapping is missing')
call assert_notequal('', maparg('<C-b>', 'n'), 'Ctrl-B mapping is missing')
call assert_notequal('', maparg('<leader>fg', 'n'), 'project search mapping is missing')
call assert_equal(2, exists(':VSCodeHelp'), ':VSCodeHelp command is missing')
call assert_equal(2, exists(':VSCodeComment'), ':VSCodeComment command is missing')

" Statusline expressions are evaluated lazily, so force their evaluation here.
if exists('*eval_statusline')
  let s:rendered_status = eval_statusline(&statusline)
  call assert_match('\[Untitled\]', s:rendered_status.str, 'statusline file expression failed')
endif

" Verify file-type indentation overrides.
enew!
setfiletype javascript
call assert_equal(2, &l:shiftwidth, 'JavaScript shiftwidth must be 2')
call assert_equal(1, &l:expandtab, 'JavaScript must use spaces')
setfiletype make
call assert_equal(0, &l:expandtab, 'Makefiles must preserve hard tabs')
call assert_equal(8, &l:tabstop, 'Makefile tabstop must be 8')

" Verify line and range comments are reversible.
enew!
setfiletype python
call setline(1, ['alpha = 1', '    beta = 2', ''])
1,2VSCodeComment
call assert_equal('# alpha = 1', getline(1), 'first line was not commented')
call assert_equal('    # beta = 2', getline(2), 'indentation was not preserved')
1,2VSCodeComment
call assert_equal('alpha = 1', getline(1), 'first line comment was not removed')
call assert_equal('    beta = 2', getline(2), 'indented comment was not removed')

" Verify paired comment markers used by markup files.
enew!
setfiletype html
call setline(1, '<main>hello</main>')
VSCodeComment
call assert_equal('<!-- <main>hello</main> -->', getline(1), 'HTML comment pair is incomplete')
VSCodeComment
call assert_equal('<main>hello</main>', getline(1), 'HTML comment pair was not removed')

" Exercise insert-mode expression mappings, including paired backspace.
enew!
call setline(1, '')
call cursor(1, 1)
call feedkeys("i(\<Esc>", 'xt')
call assert_equal('()', getline(1), 'round bracket pair was not inserted')
enew!
call setline(1, '')
call cursor(1, 1)
call feedkeys("i(\<BS>\<Esc>", 'xt')
call assert_equal('', getline(1), 'paired backspace did not remove both brackets')
enew!
call setline(1, '')
call cursor(1, 1)
call feedkeys("i'\<BS>\<Esc>", 'xt')
call assert_equal('', getline(1), 'paired backspace did not remove both quotes')

" Exercise the interactive file and search prompts with queued key input.
call feedkeys("README.md\<CR>", 't')
VSCodeFind
call assert_equal('README.md', expand('%:t'), 'Go to File did not open README.md')
call feedkeys("\<C-U>Make Vim Like VS Code\<CR>", 't')
VSCodeSearch
call assert_true(len(getqflist()) > 0, 'project search returned no quickfix entries')
call assert_true(len(filter(copy(getqflist()), 'fnamemodify(bufname(v:val.bufnr), ":t") ==# "README.md"')) > 0, 'project search did not find README.md')
cclose

" Verify the palette was actually installed.
call assert_equal('Dark', &background ==# 'dark' ? 'Dark' : 'Light', 'dark background missing')
call assert_true(synIDattr(hlID('Normal'), 'fg#') !=# '' || synIDattr(hlID('Normal'), 'fg', 'cterm') !=# '', 'Normal foreground missing')
call assert_true(synIDattr(hlID('StatusLine'), 'bg#') !=# '' || synIDattr(hlID('StatusLine'), 'bg', 'cterm') !=# '', 'StatusLine background missing')
silent! colorscheme default
let s:normal_gui_fg = tolower(synIDattr(hlID('Normal'), 'fg#'))
let s:normal_cterm_fg = synIDattr(hlID('Normal'), 'fg', 'cterm')
call assert_true(s:normal_gui_fg ==# '#d4d4d4' || s:normal_cterm_fg ==# '252', 'ColorScheme autocmd did not restore the VS Code palette')

if len(v:errors)
  for s:error in v:errors
    echomsg s:error
  endfor
  cquit 1
endif

qa!
