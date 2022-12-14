"-------------START-------------------------------
syntax on filetype plugin indent on
let mapleader = "\ "
set nocompatible

"--------------OS -----------------------------
if has('win32') || has('win16') || has ('win64')
    let g:os = 'Windows'
    let g:vim_folder ='~/vimfiles/'
    let g:ignore_file ='~/git/ignore'
else
    let g:os = substitute(system('uname'), '\n', '', '')
    let g:vim_folder ='~/.vim/'
    let g:ignore_file ='~.config/git/ignore'
endif

"--------------PLUG -----------------------------
call plug#begin(g:vim_folder . '/plugged')

Plug 'kien/ctrlp.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive'

call plug#end()


"--------------Ale -----------------------------
let g:ale_set_highlights = 1
let g:ale_linters = {'c': ['flint'] }
let g:ale_enabled = 0

"-----------RipGrep--------------------------
if g:os == 'Windows'
    let g:rg_command = 'rg --smart-case --ignore-file ~/git/ignore --vimgrep'
else
    let g:rg_command = 'rg --smart-case --ignore-file ~/.config/git/ignore --vimgrep'
endif
"statusline settings
set statusline=
set statusline+=\ %f "file name
set statusline+=%m "modified file? [+]
set statusline+=%= "go to right side of statusline
set statusline+=\ %l/%L "line out of max lines
set statusline+=\ %3p%% "percentage of file
set statusline+=\ %3c "column set statusline+=\ "
set laststatus=1 "always show statusline

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
"let g:gutentags_exclude_project_root=["./bin/", ".\bin\"./lib/boost/"]
"let g:gutentags_project_root_finder='Guten_root_fndr'
let g:gutentags_add_default_project_roots=1
"let g:gutentags_ctags_extra_args=['-B', '--fields=+iaS', '--extra=+q' ]
let g:gutentags_generate_on_empty_buffer=1
let g:gutentags_define_advanced_commands=1
let g:gutentags_enabled=1
"function! Guten_root_fndr(filepath)
"   return getcwd()
"endfunction

"------------Rebinds----------------------------
"d no longer yanks, remap to black hole register
"noremap d "_d
"nnoremap D "_D
"vnoremap d "_d
"vnoremap D "_D
"
""x no longer yanks, remap to black hole register
"nnoremap x "_x
"vnoremap x "_x

"jk and kj map to to normal mode
inoremap jk <esc>
"TODO
"tnoremap jk N

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

"center buffer when jumping around
nnoremap ]] ]]zz
nnoremap [[ [[zz
nnoremap n nzz
nnoremap N Nzz

"Y yanks till end of line
nnoremap Y y$

"don't open first file in quicklist for these functions
ca Ag Ag!
ca Glog Glog!

 "-----------Leaders-----------------------------
"open VIMRC
nnoremap <leader>$ :e $MYVIMRC<CR>

"update tags
nnoremap <leader>] :GutentagsUpdate!

"open current test in gdb
nnoremap <leader>g :call GDBTest()<CR>

"yank and paste from system clipboard
nnoremap <leader>p "+p
noremap <leader>y "+y

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

"Ctrl-P search functions in current file
nnoremap <leader>f :CtrlPFunky

"run code checker
"yank relative path of current file
noremap <leader>% :let @"=expand("%:h")

"call IWYU
noremap <leader>i :call IWYU()

"toggle ALE on/off
nnoremap <leader>a :call ALETog()

"open Location List
nnoremap <leader>l :lope

"open terminal in bottom right
nnoremap <leader>t :botr term

"open dir snippet
nnoremap <leader>o :OpenDir(" nnoremap ]] :TagbarToggle <CR>

"grep for word under cursor in header
nnoremap <leader>h :Rg =expand('') -th

"-----------editor setting ---------------------
set background=dark
set guioptions-=T
"remove toolbar set guioptions-=m
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
set guitablabel=%N)\ %{GuiTabLabel()}
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

"------------augroups/autocmnds/commands--------
"ensures autocmds are only applied once
"clear all autocommands for current group
"implement delete trailing write spaces
"set python comments to '#' (implement later)
augroup configgroup
"delete all autocommands when sourcing vimrc autocmd!
    autocmd BufWritePre *.h,*.cpp,*.py,*.jam,*.c,vimrc :%s/ \+$//ge
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
"update tags
function! UpdateTags(timer_id)
    let cwd = getcwd()
    "let tagfilename = cwd . "\\tags"
    "call delete(tagfilename)
"let cmd = 'ctags ' . '-B -R -f ' . tagfilename . ' --exclude=bin --exclude=.\lib\boost --fields=+iaS --extra=+q ' "execute 'term ' . cmd let tagfilename = cwd . "\\tags_h"
   call delete(tagfilename)
let cmd = 'ctags ' . '-B -R -f ' . tagfilename . ' --exclude=bin --exclude=.\lib\boost,*.c --fields=+iaS --c++-kinds=p --extra=+q ' execute 'term++close ' . cmd
endfunction

function! UpdateTags(timer_id)
	let cwd = getcwd()
	let tagfilename = cwd . "\\tags"
	call delete(tagfilename)
	let cmd = 'ctags ' . '-B -R -f ' . tagfilename . ' --exclude=bin --exclude=.\lib\boost --fields=+iaS --extra=+q ' "execute 'term ' . cmd "
	let tagfilename = cwd . '\\tags_h' "
	call delete(tagfilename)
	"let cmd = 'ctags ' . '-B -R -f ' . tagfilename . ' --exclude=bin --exclude=.\lib\boost,*.c --fields=+iaS --c++-kinds=p --extra=+q ' execute 'term++close ' . cmd
endfunction

"open specified directory in new tab and refresh ctags
function! OpenDir(dir)
   "Tabenter won't warm the cache since when we enter the tab we are still
   "the old cwd. This signal prevents a grep on tabenter and we do one at
   "the bottom of this function with the new cwd.
   "let g:dir_opened = 1
   let newdir="D:/git/" . a:dir
  execute 'tabnew | vsplit | vsplit | winc ='
  execute 'cd ' . newdir
  execute 'Ex | winc l'
  execute 'cd ' . newdir
  execute 'Ex | winc l'
  execute 'cd ' . newdir
  execute 'Ex | winc h | winc h'
  "Warm the cache
  "execute ":AsyncRun Rg iop>log.txt"
endfunction

function! CodeCheck()
 set makeprg=python.exe set errorformat=%f!%l!%m exe ':make!' getcwd() . "\\support\\tools\\common_scripts\\cconventions\\code_check.py " . expand("%:p") botright copen endfunction
function! CodeComplexity()
  set makeprg=python.exe
  set errorformat=%f!%l!%m
  exe ':make!' 'D:/giaw/Tools/CodeComplexityCheck/code_complexity_check.py ' . expand("%:p")
  botright copen
endfunction
"run IWYU on current file
function!
   IWYU() let l:temp_file = substitute( expand("%"), "\\", "/", "g" ) execute 'silent !start sh -c \"./iwyu2.sh ' . l:temp_file . '"'

  "old git bash compatible command
  "execute 'silent !start cmd /k "iwyu2.sh " % --max_line_length=200'
endfunction

if g:os == 'Windows'
  "setup default diff expression for windows
  set diffexpr=MyDiff()
endif

function! SortUniqQFList()
   let sortedList = sort(getqflist(), 's:CompareQuickfixEntries')
   call setqflist(sortedList)
endfunction

function! ShowFunc()
  let gf_s = &grepformat
  let gp_s = &grepprg
  let &grepformat = '%*\k%*\sfunctions%*\s%l%*\s%f %*\s%m'
  let &grepprg = 'ctags -x --c-types=f --sort=no -o -' write
  "replace backslash in file with 2 backslashed for searching
  let l:temp_file = substitute( expand("%"), "\\", "\\\\\\", "g" )
  echo l:temp_file
  execute ":grep " . l:temp_file
  let &grepformat = gf_s let &grepprg = gp_s
endfunc

function! ALETog()
  execute ":lclo"
  execute ":ALEToggle"
endfunc

function! GDBTest()
  let l_path = "prod/unittests/debug/utsim-b3mb/build/" . expand("%")
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

function! UpdatePath()
  let &path = getcwd() . '/**'
endfunc

"--------------Term -----------------------------
"has to be late or else cursor doesn't work ??
packadd termdebug
let g:termdebug_wide = 1

"-------------------------------------------
let $BASH_ENV = "/home/bfran/bin/aliases.sh"
set makeprg=buildfw
