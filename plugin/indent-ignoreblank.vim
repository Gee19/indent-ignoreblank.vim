" indent-ignoreblank.vim - Prevent vim from indenting newlines
" https://vim.fandom.com/wiki/Get_the_correct_indent_for_new_lines_despite_blank_lines
" Maintainer: Gee19 (github.com/Gee19)
" Author: Sightless (https://vim.fandom.com/wiki/User:Sightless)
" Version: 7.0

if exists('g:loaded_indent_ignoreblank') || &compatible
  finish
else
  let g:loaded_indent_ignoreblank = 'yes'
endif

let s:indent_ignore_blanks_filetypes = ['*']

if exists('g:indent_ignore_blanks_filetypes')
  let s:indent_ignore_blanks_filetypes = g:indent_ignore_blanks_filetypes
endif

function! IndentIgnoringBlanks(child) abort
  let lnum = v:lnum
  while v:lnum > 1 && getline(v:lnum-1) == ""
    normal k
    let v:lnum = v:lnum - 1
  endwhile
  if a:child == ""
    if ! &l:autoindent
      return 0
    elseif &l:cindent
      return cindent(v:lnum)
    endif
  else
    exec "let indent=".a:child
    if indent != -1
      return indent
    endif
  endif
  if v:lnum == lnum && lnum != 1
    return -1
  endif
  let next = nextnonblank(lnum)
  if next == lnum
    return -1
  endif
  if next != 0 && next-lnum <= lnum-v:lnum
    return indent(next)
  else
    return indent(v:lnum-1)
  endif
endfunction
command! -bar IndentIgnoringBlanks
            \ if match(&l:indentexpr,'IndentIgnoringBlanks') == -1 |
            \   if &l:indentexpr == '' |
            \     let b:blanks_indentkeys = &l:indentkeys |
            \     if &l:cindent |
            \       let &l:indentkeys = &l:cinkeys |
            \     else |
            \       setlocal indentkeys=!^F,o,O |
            \     endif |
            \   endif |
            \   let b:blanks_indentexpr = &l:indentexpr |
            \   let &l:indentexpr = "IndentIgnoringBlanks('".
            \   substitute(&l:indentexpr,"'","''","g")."')" |
            \ endif
command! -bar IndentNormally
            \ if exists('b:blanks_indentexpr') |
            \   let &l:indentexpr = b:blanks_indentexpr |
            \ endif |
            \ if exists('b:blanks_indentkeys') |
            \   let &l:indentkeys = b:blanks_indentkeys |
            \ endif

augroup IndentIgnoringBlanks
  autocmd!
  execute 'autocmd FileType ' . join(s:indent_ignore_blanks_filetypes, ', ') . ' IndentIgnoringBlanks'
augroup END
