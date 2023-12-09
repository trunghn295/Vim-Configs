" This is Nguyen Hoang Trung's  confiuration file for Vim.
" Its purpose is to use in all the environments that I work on.


" *************************************************************************************************
" Internal setting session:
" *************************************************************************************************
set number                    " show line number
" show space in vim
set listchars=tab:>>,trail:¶,extends:>,precedes:<
set list
filetype plugin indent on     " set tab = 3 space
set tabstop=3                 " show existing tab with 3 spaces width
set shiftwidth=3              " when indenting with '>', use 3 spaces width
set expandtab                 " On pressing tab, insert 3 spaces
syntax on                     " enable syntax highlight
set mouse=a                   " enable mouse
set colorcolumn=100           " highlight at column 100
hi ColorColumn ctermbg=lightgray guibg=gray
set cursorline                " highlight current line
set guifont=Consolas:h14
set clipboard+=unnamedplus
set spell
" turn hybrid line numbers on switch to absolute number mode if inserting
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup ENDg
" auto remove trailing space for specified files when saving
fun TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun!
" ignore trailing spaces for binary and mail files
autocmd BufWritePre * if !&binary && &ft !=# 'mail'
                   \|   call TrimWhitespace()
                   \| endif
" Use zm to fold more, zr to fold less, zc to close a fold, zo to open it,
" za to toggle between those two states, zM to close every fold, zR to open them and so on…
augroup YAML
    autocmd!
    autocmd FileType yaml setlocal foldmethod=indent foldlevelstart=999 foldminlines=0
augroup END
" *************************************************************************************************

" Auto install vim plug
if has('win32')
   " if windows, place the plug.vim in C:\Users\$USER\AppData\Local\nvim\autoload
   if empty(glob('C:\Users\$USER\AppData\Local\nvim\autoload'))
      silent !curl -fLo C:\Users\$USER\AppData\Local\nvim\autoload\plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   endif
else
   if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
         \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   endif
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

if has('win32')
   " clipboard with win32yank.exe in windows
   " in ~/bin/win32yank.exe
   " https://github.com/equalsraf/win32yank/releases {{{
   \" use "+ to copy and p to paste
   let g:clipboard = {
                           \   'name': 'win32yank-wsl',
                           \   'copy': {
                           \      '+': 'win32yank.exe -i --crlf',
                           \      '*': 'win32yank.exe -i --crlf',
                           \    },
                           \   'paste': {
                           \      '+': 'win32yank.exe -o --lf',
                           \      '*': 'win32yank.exe -o --lf',
                           \   },
                           \   'cache_enabled': 0,
                           \ }
   " }}}
endif
" *************************************************************************************************
" Plugin session:
" run :PlugInstall to install all plugins
" run :PlugUpdate to update all plugins
" run :PlugUpdate plugin_name to update a plugin
" run :PlugUpgrade to update grade vim-plug itself
" *************************************************************************************************
if has('win32')
   call plug#begin('C:/Users/$USER/AppData/Local/nvim/plugged')
else
   call plug#begin()
endif

   " Install theme
   Plug 'joshdick/onedark.vim'

   " Install nerdtree
   " This plugin is used to show the tree of dir and file as file browser in modern ide
   Plug 'preservim/nerdtree'
   Plug 'Xuyuanp/nerdtree-git-plugin'
   "   Plug 'ryanoasis/vim-devicons'

   " Install coc, an inteligent plugin
   Plug 'neoclide/coc.nvim', {'branch': 'release'}

   " Install fzf
   " This plugin will you fzf tool to search file, and use ripgrep to search
   " text in file
   " Make sure to install fzf and ripgrep first
   Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
   Plug 'junegunn/fzf.vim'

   " agriculture plugin allow use :Ag :Rg as original
   " using: eg: RgRaw 'search_text' dir -g 'file'
   Plug 'jesseleite/vim-agriculture'

   " Install syntastic, a syntax checking plugin
   " This pluging use the other code static check tool, eg pylint, shellcheck...
   Plug 'vim-syntastic/syntastic'

   " Install status bar plugin
   Plug 'vim-airline/vim-airline'
   Plug 'vim-airline/vim-airline-themes'

   " Install float terminal plugin
   Plug 'voldikss/vim-floaterm'

   " Install auto pair plugin
   Plug 'jiangmiao/auto-pairs'

   " Install below plugins for plant uml
   " If want to use plantmul plugin, then uncomment 3 below lines
   " Plug 'aklt/plantuml-syntax'
   " Plug 'tyru/open-browser.vim'
   " Plug 'weirongxu/plantuml-previewer.vim'
   
call plug#end()
" *************************************************************************************************


" *************************************************************************************************
" Plugin Setting session
" *************************************************************************************************
" Start NERDTree. If a file is specified, move the cursor to its window.
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
" specify a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
if has('win32')
   " Exit Vim if NERDTree is the only window remaining in the only tab.
   autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1
      \ && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
   " Close the tab if NERDTree is the only window remaining in it.
   autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree')
      \ && b:NERDTree.isTabTree() | quit | endif
endif
" Ignore certain files and folders
let NERDTreeIgnore = ['\.pyc$', '^__pycache__$', '\.exe$']
let NERDTreeShowHidden=1
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'U',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }

" Install coc extension if they were not installed
" We can add config in coc-settings.json file without using below extension
" To config coc-settings.json file, create one and copy to /home/$USER/.config/nvim/coc-settings.json
if empty(glob('~/.config/coc/extensions/node_modules/coc-json'))
   autocmd VimEnter * CocInstall coc-json
endif
if empty(glob('~/.config/coc/extensions/node_modules/coc-tsserver'))
   autocmd VimEnter * CocInstall coc-tsserver
endif
if empty(glob('~/.config/coc/extensions/node_modules/coc-clangd'))
   autocmd VimEnter * CocInstall coc-clangd
endif
if empty(glob('~/.config/coc/extensions/node_modules/coc-sh'))
   autocmd VimEnter * CocInstall coc-sh
endif


" Set vim-airline smart tab
" Enable the list of buffer
let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" Show just the file name
let g:airline#extensions#tabline#fnamemod = ':t'


" set syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" *************************************************************************************************


" *************************************************************************************************
" Mapping session
" *************************************************************************************************
" Mapping fzf
nnoremap <silent> <C-f> :Files<CR>

" Mapping nerdtree
nnoremap <silent> <Tab> :NERDTreeToggle<CR>
" find the current file in tree, change current dir to that dir
nnoremap <silent> ,tf :NERDTreeFind<CR>:pwd<CR>
nnoremap <silent> ,tn :NERDTree<CR>
" nnoremap <silent> <Left> <C-W><C-H><CR>
" nnoremap <silent> <Right> <C-W><C-L><CR>
" nnoremap <silent> <Up> <C-W><C-K><CR>
" nnoremap <silent> <Down> <C-W><C-J><CR>

" Mapping floaterm
let g:floaterm_position = 'topright'
nnoremap <silent> <S-t> :FloatermNew --height=0.8 --width=0.7 --wintype=float --title="terminal"<CR>
nnoremap <silent> <S-Tab> :FloatermToggle<CR>
tnoremap <silent> <S-Tab> <C-\><C-n>:FloatermToggle<CR>
hi FloatermBorder guibg=gray guifg=cyan
" Switch between floaterm in terminal mode
tnoremap <A-Left> <C-\><C-n>:FloatermPrev<CR>
tnoremap <A-Right> <C-\><C-n>:FloatermNext<CR>
tnoremap <A-Up> <C-\><C-n>:FloatermFirst<CR>
tnoremap <A-Down> <C-\><C-n>:FloatermLast<CR>


" Mapping vim-airline
nnoremap <C-Left> :bprevious<CR>
nnoremap <C-Right> :bnext<CR>
nnoremap <C-Up> :bfirst<CR>
nnoremap <C-Down> :blast<CR>


" Mapping syntastic
" Ctrl + c to check code, ctrl + u to uncheck
nnoremap <silent> <C-c> :SyntasticCheck <CR>
nnoremap <silent> <C-u> :SyntasticToggleMode <CR>

" Internal mapping
" default:
" " <C-x>s => check spell in insert mode
" Resize panel
nmap <S-Right> :vertical resize +1 <CR>
nmap <S-Left> :vertical resize -1 <CR>
nmap <S-Up> :resize +1 <CR>
nmap <S-Down> :resize -1 <CR>
" copy File Name
nmap ,fn :let @+ = expand("%")<CR>
" copy file path
nmap ,fp :let @+ = expand("%:p")<CR>
" change dir
nmap ,cd :cd %:p:h<CR>:pwd<CR>
"
nnoremap  <C-K> <C-W>k
nnoremap  <C-J> <C-W>j
nnoremap  <C-H> <C-W>h
nnoremap  <C-L> <C-W>l
" *************************************************************************************************

" Include extended vim config files
if has("macunix")
   let nvim_conf_dir = '/Users/$USER/.config/nvim/'
else
   let nvim_conf_dir = '$HOME/.config/nvim/'
endif
execute 'source '.nvim_conf_dir.'coc.vim'
"
" set to use onedark theme but none background
colorscheme onedark
hi Normal guibg=NONE ctermbg=NONE

