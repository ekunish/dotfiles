version 6.0
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
let &cpo=s:cpo_save
unlet s:cpo_save
set backspace=2
set fileencodings=ucs-bom,utf-8,default,latin1
set helplang=ja
set modelines=0
set window=0

##### vundle #####
set nocompatible
filetype off

set rtp+=~/github/dotfiles/.vim/vundle.git/
call vundle#rc()






" vim: set ft=vim :
