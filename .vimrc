"���顼��������
syntax enable
"colorscheme


"�ӡ��ײ��ò�
set visualbell
"�������ԤΥ���ǥ�Ȥ򸽺߹Ԥ�Ʊ���ˤ���
set autoindent
"�ե�������¸���������ν���ǥ��쥯�ȥ��Хåե��ե�������֤�����
set browsedir=buffer 
"����åץܡ��ɤ�Windows��Ϣ��
set clipboard=unnamed
"Vi�ߴ��򥪥�
set nocompatible
"�ѹ���Υե�����Ǥ⡢��¸���ʤ���¾�Υե������ɽ��
set hidden
"���󥯥��󥿥륵������Ԥ�
set incsearch
"����ʸ���������ʤ��ԲĻ�ʸ����ɽ������
set list
"list��ɽ�������ʸ���Υե����ޥåȤ���ꤹ��
set listchars=eol:$,tab:>\ ,extends:<
"���ֹ��ɽ������
set number
"�ե�������� <Tab> ���б��������ο�
set tabstop=4
"���֤�����˶���ʸ������������
set expandtab
"���եȰ�ư��
set shiftwidth=4
"�Ĥ���̤����Ϥ��줿�Ȥ����б������̤�ɽ������
set showmatch
"����������ʸ����ޤ�Ǥ�������/�������
set smartcase
"�������Ԥ��ä��Ȥ��˹��٤ʼ�ư����ǥ�Ȥ�Ԥ�
set smartindent
"��Ƭ��;����� Tab ���Ǥ�����ȡ�'shiftwidth' �ο���������ǥ�Ȥ��롣
set smarttab
"����������Ƭ�������ǻߤޤ�ʤ��褦�ˤ���
set whichwrap=b,s,h,l,<,>,[,]
"������ե��������Ƭ�إ롼�פ��ʤ�
set nowrapscan
" ���ơ������饤�����ɽ��
set laststatus=2
" ����λ������������Ԥ˰�ư
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

"""""""""""""""""""""""""""
" auto comand
"""""""""""""""""""""""""""
"���ϥ⡼�ɻ������ơ������饤��Υ��顼���ѹ�
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END
"
""���ܸ����Ϥ�ꥻ�å�
au BufNewFile,BufRead * set iminsert=0
"��������ꥻ�å�
au BufNewFile,BufRead * set tabstop=4 shiftwidth=4
"
".txt�ե�����Ǽ�ưŪ�����ܸ�����ON
au BufNewFile,BufRead *.txt set iminsert=2
".rhtml��.rb�ǥ��������ѹ�
au BufNewFile,BufRead *.rhtml   set nowrap tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.rb  set nowrap tabstop=2 shiftwidth=2

"���ѥ��ڡ������в�
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /��/

".txt�ե�����Ǽ�ưŪ�����ܸ�����ON
au BufNewFile,BufRead *.txt set iminsert=2


"""""""""""""""""""""""""""""""
" encoding
"""""""""""""""""""""""""""""""
" ʸ�������ɤμ�ưǧ��
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconv��eucJP-ms���б����Ƥ��뤫������å�
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconv��JISX0213���б����Ƥ��뤫������å�
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodings����
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " ������ʬ
  unlet s:enc_euc
  unlet s:enc_jis
endif
" ���ܸ��ޤޤʤ����� fileencoding �� encoding ��Ȥ��褦�ˤ���
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" ���ԥ����ɤμ�ưǧ��
set fileformats=unix,dos,mac
" ���Ȥ�����ʸ�������äƤ⥫��������֤�����ʤ��褦�ˤ���
if exists('&ambiwidth')
  set ambiwidth=double
endif

" -------------------
" plugin
" -------------------

" Vundle
set nocompatible
filetype off

set rtp+=~/dotfiles/.vim/vundle.git/
call vundle#rc()
Bundle 'Smooth-Scroll'
Bundle 'surround.vim'
Bundle 'quickrun'

Bundle 'Shougo/neocomplcache'
Bundle 'ujihisa/unite-colorscheme'

filetype plugin indent on


" -------------------
" neocomplcashe
" -------------------

" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" SuperTab like snippets behavior.
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" AutoComplPop like behavior.
let g:neocomplcache_enable_auto_select = 1


