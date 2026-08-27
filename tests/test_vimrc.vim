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
call assert_equal(2, exists(':VSCodeFilesRefresh'), ':VSCodeFilesRefresh command is missing')
call assert_equal(2, exists(':VSCodeOnlyBuffer'), ':VSCodeOnlyBuffer command is missing')

" Reloading the file must not grow comma-separated path options.
let s:undo_before_reload = &undodir
let s:vimrc_path = fnamemodify(resolve(expand('<sfile>:p')), ':h:h') . '/.vimrc'
execute 'source ' . fnameescape(s:vimrc_path)
call assert_equal(s:undo_before_reload, &undodir, 'reloading duplicated the persistent undo directory')

" Statusline expressions are evaluated lazily, so force their evaluation here.
if exists('*eval_statusline')
  let s:rendered_status = eval_statusline(&statusline)
  call assert_match('\[Untitled\]', s:rendered_status.str, 'statusline file expression failed')
  call assert_match('\%(NORMAL\|COMMAND\)', s:rendered_status.str, 'statusline mode label is not readable')
endif

" Verify file-type indentation overrides.
enew!
setfiletype javascript
call assert_equal(2, &l:shiftwidth, 'JavaScript shiftwidth must be 2')
call assert_equal(1, &l:expandtab, 'JavaScript must use spaces')
setfiletype make
call assert_equal(0, &l:expandtab, 'Makefiles must preserve hard tabs')
call assert_equal(8, &l:tabstop, 'Makefile tabstop must be 8')

" Verify file-type-specific HDL dictionaries and actual Tab completion.
enew!
doautocmd BufNewFile sample.VHD
call assert_equal('vhdl', &l:filetype, 'uppercase .VHD detection failed')
enew!
doautocmd BufNewFile sample.vh
call assert_equal('verilog', &l:filetype, '.vh detection failed')
enew!
doautocmd BufNewFile sample.SVH
call assert_equal('systemverilog', &l:filetype, 'uppercase .SVH detection failed')

enew!
setlocal filetype=vhdl
call assert_equal(1, get(b:, 'vscode_dictionary_completion', 0), 'VHDL dictionary was not enabled')
call assert_equal('vhdl.dict', fnamemodify(b:vscode_dictionary_path, ':t'), 'wrong VHDL dictionary')
call assert_true(index(split(&l:complete, ','), 'k') >= 0, 'dictionary source missing from complete')
call assert_equal('--', b:vscode_comment_marker, 'wrong VHDL comment marker')
call assert_equal(2, &l:shiftwidth, 'VHDL shiftwidth must be 2')
call setline(1, 'arch')
call cursor(1, 1)
call feedkeys("A\<Tab>\<Esc>", 'xt')
call assert_equal('architecture', getline(1), 'VHDL Tab completion failed')
call append(1, '')
call cursor(2, 1)
call feedkeys("A\<Tab>\<Esc>", 'xt')
call assert_equal('  ', getline(2), 'HDL Tab indentation fallback failed')

enew!
setlocal filetype=verilog
call assert_equal('verilog.dict', fnamemodify(b:vscode_dictionary_path, ':t'), 'wrong Verilog dictionary')
call assert_equal('//', b:vscode_comment_marker, 'wrong Verilog comment marker')
call setline(1, 'localp')
call cursor(1, 1)
call feedkeys("A\<Tab>\<Esc>", 'xt')
call assert_equal('localparam', getline(1), 'Verilog Tab completion failed')

enew!
setlocal filetype=systemverilog
call assert_equal('systemverilog.dict', fnamemodify(b:vscode_dictionary_path, ':t'), 'wrong SystemVerilog dictionary')
call assert_equal('//', b:vscode_comment_marker, 'wrong SystemVerilog comment marker')
call setline(1, 'always_')
call cursor(1, 1)
call feedkeys("A\<Tab>\<Esc>", 'xt')
call assert_equal('always_comb', getline(1), 'SystemVerilog multi-candidate Tab completion failed')
call setline(1, 'always_')
call cursor(1, 1)
call feedkeys("A\<Tab>\<Tab>\<Esc>", 'xt')
call assert_equal('always_ff', getline(1), 'Tab did not advance to the next dictionary candidate')

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
setlocal filetype=python
call setline(1, 'value = 1')
VSCodeComment
call assert_equal('# value = 1', getline(1), 'comment suffix leaked across file types')

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

" Closing other buffers must preserve modified content and remove safe buffers.
enew!
file keep-buffer.txt
setlocal nomodified
let s:keep_buffer = bufnr('%')
enew!
file disposable-buffer.txt
setlocal nomodified
let s:disposable_buffer = bufnr('%')
execute 'buffer ' . s:keep_buffer
VSCodeOnlyBuffer
call assert_false(buflisted(s:disposable_buffer), 'unmodified buffer was not closed')
enew!
file modified-buffer.txt
call setline(1, 'unsaved work')
let s:modified_buffer = bufnr('%')
execute 'buffer ' . s:keep_buffer
VSCodeOnlyBuffer
call assert_true(buflisted(s:modified_buffer), 'modified buffer was discarded')
execute 'bdelete! ' . s:modified_buffer

" Exercise the interactive file and search prompts with queued key input.
call feedkeys("RME\<CR>", 't')
VSCodeFind
call assert_equal('README.md', expand('%:t'), 'fuzzy Go to File did not open README.md')
call feedkeys("\<C-U>path=.,**\<CR>", 't')
VSCodeSearch
call assert_true(len(getqflist()) > 0, 'project search returned no quickfix entries')
call assert_true(len(filter(copy(getqflist()), 'fnamemodify(bufname(v:val.bufnr), ":t") ==# ".vimrc"')) > 0, 'literal project search did not find .vimrc')
cclose
call feedkeys("\<C-U>runs-on: ubuntu-latest\<CR>", 't')
VSCodeSearch
call assert_true(len(filter(copy(getqflist()), 'fnamemodify(bufname(v:val.bufnr), ":t") ==# "test.yml"')) > 0, 'project search skipped .github content')
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
