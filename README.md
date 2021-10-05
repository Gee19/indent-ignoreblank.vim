# indent-ignoreblank.vim

Get the correct indent for new lines despite blank lines.

Often when you enter a blank line by pressing Enter twice in insert mode, Vim removes the indent from the blank line and your cursor moves back to column 1. Likewise, if you position the cursor on a blank line and press letter o to open a new line below it, Vim does not open that line with any indent. Often, though, you want to use the same indent as the preceding non-blank line.

This plugin works by 'wrapping' your indentexpr in another. The script sets the indentexpr to its own wrapper function, which adjusts the cursor position and variables as if you were inserting directly after the last non-blank line, not after the blank line, and then evaluates the original indentexpr. 

## Installation

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'Gee19/indent-ignoreblank.vim'
```

## Configuration

You can set a global variable in your vimrc to pass filetypes to this plugin (defaults to `['*']`)

`let g:indent_ignore_blanks_filetypes = ['*.py', 'javascript']`

## TODO
- Toggleable

## Credit

All credit goes to [Sightless](https://vim.fandom.com/wiki/Get_the_correct_indent_for_new_lines_despite_blank_lines). I simply created this plugin to clean up my vimrc.
