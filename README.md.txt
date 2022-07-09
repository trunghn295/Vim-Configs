This project is to automatically install vim/neovim and necessary tools,
plugins for any environments that I will work on.
Firstly, it supports only Linux environment, but in the future, it also supports Mac OS.

Usage: vim_setup.sh

Some tips:
Vim
- Shift + Left, Right, Up, Down to resize the editor screen

Nerdtree:
- press Left key to switch to Nerdtree, Right key to switch to buffer
- in nerdtree, press 'm' to add, remove, or edit files/dir

Airline:
Ctrl + Right/Left/Up/Down to move among the buffers
type ":bd[bufer_number]" to delete the buffer

fzf
If opening fzf but then open floaterm, then we cannot use ESC to turn off fzf.
Then switch to insert mode to continue

Rg
type ":RgRaw search_string -g FileType Dir" to search string in directory

ctags
we need to run "ctags -R ." at the top of dir to create tags file, it will be used in vim
ctrl+] to jump to definition, ctrl+o to jump back
ctags will be remove when the LSP is installed in the machine. LSP solution is better
to go through code

floaterm
Alt + Left, Right, Up, Down to switch between floaterm windows
if cannot edit, press i to get back to insert mode

to exit terminal mode: Ctrl + \ + n

coc
to use coc we need to set up a separated LSP.
example, for C/C++ we need to set up llvm, clangd
and we can decide to use coc extension to connect with LSP or setting in coc-setting.json
https://github.com/neoclide/coc.nvim/wiki/Language-servers

tip to open vim
nvim +linenumber file => open file and go to the specify linenumber
nvim +/pattern file => open file and search for the pattern
nvim -d file file => open 2 files and show the diff
nvim -c "normal command" file => open file and execute a command
command | nvim - => open output of shell command in vim

