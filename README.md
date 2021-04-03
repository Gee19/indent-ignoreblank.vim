# indent-ignoreblank.vim

Get the correct indent for new lines despite blank lines.

Often when you enter a blank line by pressing Enter twice in insert mode, Vim removes the indent from the blank line and your cursor moves back to column 1. Likewise, if you position the cursor on a blank line and press letter o to open a new line below it, Vim does not open that line with any indent. Often, though, you want to use the same indent as the preceding non-blank line.

This plugin works by 'wrapping' your indentexpr in another. The script sets the indentexpr to its own wrapper function, which adjusts the cursor position and variables as if you were inserting directly after the last non-blank line, not after the blank line, and then evaluates the original indentexpr. 

## Installation

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'Gee19/indent-ignoreblank.vim'
```

or add the following to your vimrc:

```
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
  au!
  au FileType * IndentIgnoringBlanks
augroup END
```
You can change the `*` in the `au` command at the bottom to make it apply to only the filetypes you want, or put the part after the * in after scripts instead of with the above. [:help after-directory](http://vimdoc.sourceforge.net/htmldoc/options.html#after-directory)

## Configuration (WIP)

- Pass in filetypes to be used in the autocmd
- Toggleable

## Credit

All credit goes to [Sightless](https://vim.fandom.com/wiki/Get_the_correct_indent_for_new_lines_despite_blank_lines). I simply created this plugin to clean up my vimrc.
