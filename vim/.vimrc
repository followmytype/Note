set number
set nowrap
set ruler
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set ai
filetype indent on

syntax on

set t_Co=256
colorscheme codedark
set cursorline

set encoding=utf-8

:inoremap( ()<Esc>i
:inoremap" ""<Esc>i
:inoremap' ''<Esc>i
:inoremap[ []<Esc>i
:inoremap{ {<CR>}<Esc>ko
