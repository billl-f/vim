"-------------START-------------------------------
syntax on filetype plugin indent on
let mapleader = "\ "
set nocompatible

"--------------OS -----------------------------
if has('win32') || has('win16') || has ('win64')
    let g:os = 'Windows'
    let g:vim_folder ='~/vimfiles/'
    let g:ignore_file ='~/git/ignore'
    "note: ~ doesn't work here due to rg external cmd
    let g:rgignore_file ='C:/users/bfraney/.rgignore'
    " $HOME/.vimrc
    set directory=~/vimfiles/swap//"
else
    let g:os = substitute(system('uname'), '\n', '', '')
    let g:vim_folder ='~/.vim/'
    let g:ignore_file ='~/.config/git/ignore'
    let g:rgignore_file ='~/.config/rgignore'
    set directory=~/.vim/swap//"
endif

"make swapfile folders if it doesn't exist
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

"--------------PLUG -----------------------------
call plug#begin(g:vim_folder . '/plugged')

Plug 'kien/ctrlp.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'tpope/vim-fugitive'
Plug 'axvr/org.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ojroques/vim-oscyank', {'branch': 'main'}
"uml
Plug 'tyru/open-browser.vim'
Plug 'aklt/plantuml-syntax'
Plug 'weirongxu/plantuml-previewer.vim'
"end uml

call plug#end()

"--------------plantuml-previewer---------------
"install: download openjdk and add bin folder to path
"unclear why needed
let g:plantuml_previewer#debug_mode = 1

"--------------Ale -----------------------------
let g:ale_set_highlights = 1
let g:ale_linters = {'c': ['flint'] }
let g:ale_enabled = 0

"-----------RipGrep--------------------------
"let g:rg_command = 'rg --smart-case --ignore-file ' . g:ignore_file . ' --vimgrep -t c -t cpp -t py -t cmake'
let g:rg_command = "rg --smart-case --vimgrep --ignore-file " .  g:rgignore_file

"statusline settings
set statusline=
set statusline+=\ %f "file name
set statusline+=%m "modified file? [+]
set statusline+=%= "go to right side of statusline
set statusline+=\ %l/%L "line out of max lines
set statusline+=\ %3p%% "percentage of file
set statusline+=\ %3c "column set statusline+=\ "
set laststatus=2 "always show statusline

"------------CtrlP------------------------------
"can change working path directory ----might be 0 instead of rw. unsure.
let g:ctrlp_working_path_mode = '0'
let g:ctrlp_by_filename = 1
let g:ctrlp_match_window = 'bottom,ttb,min:1,max:25,results:25'
"stopped working when moved pack to vimfiles
"let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
"use the HOTTEST new file searcher: ripgrep
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --ignore-file ' . g:ignore_file . ' --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

"Actually map to ctrl p
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

"remove CtrlP statusline
let g:ctrlp_buffer_func = { 'enter': 'Status1', 'exit': 'Status2', }

func! Status1()
   set laststatus=0
endfunc

func! Status2()
  set laststatus=2
endfunc

"------------Gutentags------------------------------
"NOTE: NEEDS UNIVERSAL
"let g:gutentags_project_root_finder='Guten_root_fndr'
let g:gutentags_project_root=[".git"]
let g:gutentags_add_default_project_roots=1
"let g:gutentags_ctags_extra_args=['-B','--fields=+iaS', '--extra=+q' ]
"NOTE: may need to use --map instead, headers aren't a part of c langmap
"let g:gutentags_ctags_extra_args=['-B','--languages=C,Python --langmap=c:.cpp.c.h' ]
let g:gutentags_ctags_extra_args=['-B','--languages=C,C++,Python --kinds-C++=+Z' ]

"pretty much always generate tags
let g:gutentags_generate_on_empty_buffer=1
let g:gutentags_generate_on_missing=1
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_write=1

let g:gutentags_define_advanced_commands=1
let g:gutentags_enabled=1
"function! Guten_root_fndr(filepath)
"   return getcwd()
"endfunction

"====Gutentags Plus========
"NOTE: requires GNU Global and python in path
"NOTE: GTAGS not found: since it uses incremental update, it expects GTAGS to exist already
"install gnu global then open any source file to generate
packadd cfilter

let g:gutentags_modules = ['ctags', 'gtags_cscope']
" generate datebases in my cache directory, prevent gtags files polluting my project
"let g:gutentags_cache_dir = expand('~/.cache/tags')
" change focus to quickfix window after search (optional).
let g:gutentags_plus_switch = 1
"dont use default maps
let g:gutentags_plus_nomap = 1
let g:gutentags_plus_height = 12

"tag symbol
nnoremap <leader>ts :GscopeFind 0 <c-r>=expand('<cword>') <CR> <CR>
"tag usage
nnoremap <leader>tu :GscopeFind 3 <c-r>=expand('<cword>') <CR> <CR>

"source only
"tag symbol code-only
nnoremap <leader>tss :GscopeFind 0 <c-r>=expand('<cword>') <CR> <CR> :Cfilter! test<CR> :Cfilter! mock<CR>
"find usage code-only
nnoremap <leader>tus :GscopeFind 3 <c-r>=expand('<cword>') <CR> <CR> :Cfilter! test<CR> :Cfilter! mock<CR>

"test only
"tag symbol test-only
nnoremap <leader>tst :GscopeFind 0 <c-r>=expand('<cword>') <CR> <CR> :Cfilter src<CR>
"tag usage test-only
nnoremap <leader>tut :GscopeFind 3 <c-r>=expand('<cword>') <CR> <CR> :Cfilter src<CR>

function! AddHeader()
  let &path = getcwd() . '/**'
endfunc

function! GutentagsCleaner()
  !rm GTAGS GRTAGS GPATH tags
endfunc

command! GutentagsClean :call GutentagsCleaner()

"------------Rebinds----------------------------
"d no longer yanks, remap to black hole register
"nnoremap d "_d
"nnoremap D "_D
"vnoremap d "_d
"vnoremap D "_D
"
""x no longer yanks, remap to black hole register
nnoremap x "_x
vnoremap x "_x

"jk and kj map to to normal mode
inoremap jk <esc>

"go up and down visually in normal mode
nnoremap j gj
nnoremap k gk

"terminal escape
if v:version >= 800
    tnoremap <esc> <c-\><c-n>
    tnoremap jk <c-\><c-n>
endif

"Better window navigation
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h
tnoremap <C-j> <C-W>j
tnoremap <C-k> <C-W>k
tnoremap <C-l> <C-W>l
tnoremap <C-h> <C-W>h

"center buffer when jumping around functions
nnoremap ]] ]]zz
nnoremap [[ [[zz

"Y yanks till end of line
nnoremap Y y$

"don't open first file in quicklist for these functions
ca Ag Ag!
ca Glog Glog!

 "-----------Leaders-----------------------------
"open VIMRC
nnoremap <leader>$ :e $MYVIMRC<CR>

"open current test in gdb
nnoremap <leader>gt :call GDBTest()<CR>
"open remote hw gdb session
nnoremap <leader>gr :call GDBHwRemote()<CR>
"open local hw gdb session
nnoremap <leader>gl :call GDBHwLocal()<CR>

"yank and paste from system clipboard
nnoremap <leader>p "+p
nnoremap <leader>y "+y
nnoremap <leader>Y "+y$
vnoremap <leader>p "+p
vnoremap <leader>y "+y
vnoremap <leader>Y "+y$

nmap <leader>c <Plug>OSCYankOperator
vmap <leader>c <Plug>OSCYankVisual

"stop highlighting searches
nnoremap <leader>/ :nohlsearch<CR>

"grep for word under cursor
"nnoremap <leader>* :Rg --sort-files -F <c-r>=expand('<cword>') <CR><CR>
if executable('rg')
    nnoremap <leader>* :Rg --sort-files <c-r>=expand('<cword>') <CR><CR>
elseif executable('grep')
    nnoremap <leader>* :grep <cword> *<CR>
endif

"Ctrl-P search buffers
nnoremap <leader>b :CtrlPBuffer<CR>

"open terminal in bottom right
nnoremap <leader>t :botr term

"toggle change to build dir for quickfix errors
nnoremap <leader>m :call GoMake()<CR>

"yank relative path
nnoremap <leader>yr :let @"=expand("%")<CR>

"yank full path
nnoremap <leader>yp :let @"=expand("%:p")<CR>

"yank filename
nnoremap <leader>yf :let @"=expand("%:t")<CR>

"-----------editor setting ---------------------
set background=dark
set guioptions-=T
"remove toolbar
set guioptions-=m
"remove menu
set guioptions-=r
"remove right scrollbar
set guioptions-=l
"remove left scrollbar
set guioptions-=L
"remove left scrollbar during vsp
set guioptions+=c
"use console dialogs
set guioptions+=e
"for tab label
"set guitablabel=%N)\ %{GuiTabLabel()}
"tab number + custom tab label
set enc=utf-8
set guifont=Consolas:h11:cANSI

if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window.
  set lines=999 columns=999
  colorscheme desert
  "maximize window (removing menu leaves a little extra space)
  autocmd GUIEnter * simalt ~x
  "remove annoying background highlighting for matching paren
  hi MatchParen guibg=NONE guifg=red

  "change highlight color so you can actually see the cursor
  hi Search guifg=DarkCyan
  hi IncSearch guifg=DarkRed

else
  "This is console Vim.
  colorscheme desert
  "change highlight color so you can actually see the cursor
  hi Search ctermbg=DarkRed
  hi IncSearch ctermfg=DarkCyan
  "arcane settings to get block cursor for normal mode
  let &t_ti.="\e[1 q"
  let &t_SI.="\e[5 q"
  let &t_EI.="\e[1 q"
  let &t_te.="\e[0 q"
endif


"case insensitive searching
set ignorecase

"become case sensitive when a capital is typed
set smartcase

"replace all tabs with spaces
set expandtab
"
""read files with tabs as 4 spaces
set softtabstop=4
"
""number of spaces to move in an autoindent
set shiftwidth=4

"search while typing in search query
set incsearch

"highlight searches
set hlsearch

"make backspace work like normal programs
set backspace=indent,eol,start

"don't wrap text on next line
set nowrap

"don't redraw window during macro execution to increase speed
set lazyredraw

"ignore files during file/dir completion
set wildignore+=*/.git/*

"faster key timeout
set ttimeoutlen=50

"allow indenting of some c commands
set cindent

"'if' brace indenting is 1 shiftwidth
"set cinoptions={1s

"start in col 0 after brace in col 0
"set cinoptions+=^-1s

" This should make the text for comment blocks
" start on the same column as the slash /
"set cinoptions+=c0,C1

" This should have multi-line conditionals to start
" on the column after the (
"set cinoptions+=(0,u0,w1

"set 'normal' shifting
set cinoptions+=>1s

"remove indent after o and O
"set cinkeys-=o,O
"add newline at end of file set eol
"do not unload buffer when it is left
set hidden

"remove some paths to speed up find ( find currently so slow it's unusable )
set wildignore+=*/bin/**
set wildignore+=*/support/**
set wildignore+=*/sim/**

"make normal mode commands like 'w' respect path delimiter "/" "sometimes i want to yank just the file name, not whole path
set iskeyword-=/

"make = a file name delimiter
set isfname-==

"------------augroups/autocmnds/commands--------
"ensures autocmds are only applied once
"clear all autocommands for current group
"implement delete trailing write spaces
"set python comments to '#' (implement later)
augroup configgroup
"delete all autocommands when sourcing vimrc autocmd!
    autocmd BufWritePre vimrc,*.h,*.cpp,*.py,*.jam,*.c :%s/ \+$//ge
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd FileType *.c, *.h setlocal spell
    autocmd FileType *.dtsi make set noexpandtab
    autocmd BufEnter ControlP let b:ale_enabled = 0
    autocmd TabEnter * :call UpdatePath()
    "close quickfix whenever I select an option
    "autocmd FileType qf nnoremap :cclose
augroup END

"execute argument in cmd.exe from cwd
command! -nargs=* Start execute 'silent !start cmd /k ' . ""

"open dir
command! -nargs=1 OpenDir call OpenDir()

"update tags every 1000 minutes
"let temptmr = timer_start(60000000,'UpdateTags', {'repeat':-1})
"generate help tags
"helptags $VIMRUNTIME

"----------custom functions--------------------- "
function! GDBHwRemote()
  let g:termdebug_config = {}
  let g:termdebug_config['wide'] = 163
  let g:termdebug_config['command'] = ["gdb-multiarch",
              \ "-ex", "target extended-remote lm-bfran-chewy.elements.local:3333",
              \ "-q",
              \ "-ex", "set backtrace limit 20",
              \ "-ex", "monitor gdb_breakpoint_override hard",
              \ "--symbols=./prod/bhb/debug/hwpp-kv7/build/bhb-hwpp.axf"]
  execute ":Termdebug"
  winc =
endfunc

function! GDBHwLocal()
  let g:termdebug_config = {}
  let g:termdebug_config['wide'] = 163
  let g:termdebug_config['command'] = ["gdb-multiarch",
              \ "-q",
              \ "-ex", "set backtrace limit 20",
              \ "-ex", "monitor gdb_breakpoint_override hard",
              \ "--symbols=./prod/hud/debug/hwmainfw-kv7/build/bhb-hwpp.axf"]
  execute ":Termdebug"
  winc =
endfunc

function! GDBTest()
  let g:termdebug_config = {}
  let g:termdebug_config['wide'] = 163
  let l_path = "prod/unittests/debug/utsim-kv7/build/" . expand("%")
  "libraries has special handling
  if l_path =~ "/lib/"
    "extract the lib name which is also test name
    let l_path2 = split(l_path, "/lib/")[1]
    let l_path2 = split(l_path2, "/")[0]
    "remove test folder from path
    let l_path = split(l_path, "test/")[0]
    "add in lib name to path
    let l_path = l_path . "test_" . l_path2
  else
    "remove test folder from path
    let l_path = split(l_path, "test/")[0] . expand("%:t")
    "remove .cpp
    let l_path = split(l_path, ".cpp")[0]
  endif
  winc |
  execute ":Termdebug " . l_path
  winc l
endfunc

if g:os == 'Windows'
  "setup default diff expression for windows
  set diffexpr=MyDiff()
endif


function! UpdatePath()
  let &path = getcwd() . '/**'
endfunc

"--------------Term -----------------------------
"has to be late or else cursor doesn't work ??
packadd termdebug

"legacy, replaced by g:termdebug_config
let g:termdebug_wide = 1

"-------------building --------------------------
let $BASH_ENV = "/home/bfran/bin/aliases.sh"
set makeprg=buildfw

"------quickfix build dir---------------
let s:toggle=0
let s:cwd="~/code/trenton"
function! GoMake()
    let s:toggle=xor(s:toggle, 1)
    if s:toggle
        cd prod/bhb/debug/hwpp-kv7/build
        execute ":pwd"
    else
        execute ":cd " . s:cwd
        execute ":pwd"
    endif
endfunc
