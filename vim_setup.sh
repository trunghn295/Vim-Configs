#!/bin/bash

# author: Trung Nguyen Hoang
# This script will check and install necessary vim env
# It should be used with vimrc and other config files which provided in the same location


# Check and install neovim
if ! which nvim; then
   echo "installing latest stable neovim..."
   sudo add-apt-repository ppa:neovim-ppa/stable
   sudo apt-get update
   sudo apt-get install neovim
else
   echo "neovim is already installed"
fi


# Check and install nodejs which is used for coc plugin
if ! which nodejs; then
   echo "installing nodejs..."
   sudo curl -sL install-node.vercel.app/lts | sudo bash
else
   echo "nodejs is already installed"
   nodejs_version=$(nodejs -v)
   if [ "$nodejs_version" \< "v12.12.0" ]; then
      echo "upgrading the nodejs to latest stable version..."
      sudo npm cache clean -f
      sudo npm install -g n
      sudo n stable
   fi
fi


# Check and install fzf
if ! which fzf; then
   echo "installing fzf..."
   #sudo apt install fzf
   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
   ~/.fzf/install
else
   echo "fzf is already installed"
fi
# maybe we need to add below configuration to ~/.bashrc file before install fzf plugin
# if tpe rg &> /dev/null; then
#   export FZF_DEFAULT_COMMAND='rg --files'
#   export FZF_DEFAULT_OPTS='-m --height 50% --border'
# fi
# https://dev.to/iggredible/how-to-search-faster-in-vim-with-fzf-vim-36ko

# Check and install ripgrep, it is used with fzf
if ! which rg; then
   echo "installing ripgrep..."
   curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
   sudo dpkg -i ripgrep_13.0.0_amd64.deb
else
   echo "fzf is already installed"
fi


# check and install ctags, used to navigate in code
if ! which ctags; then
   echo "installing ctags..."
   sudo apt install ctags
else
   echo "ctags is already installed"
fi

# install vim-gtk to support clipboard
# if cannot use clipboard in ssh mode, remember to call 'export DISPLAY=:0.0' before start vim
if ! dpkg -s vim-gtk; then
   echo "installing vim-gtk..."
   sudo apt install vim-gtk
   echo "adding export DISPLAY to bashrc file..."
   echo "if [[ -n \$SSH_CONNECTION ]] ; then" >> "$HOME/.bashrc"
   echo "  echo \"exporting DISPLAY...\"" >> "$HOME/.bashrc"
   echo "  export DISPLAY=:0.0" >> "$HOME/.bashrc"
   echo "fi" >> "$HOME/.bashrc"
else
   echo "vim-gtk is already installed"
fi


# for llvm, clang and clangd, they should be installed manually,
# because they are only for c/c++, some projects work on the other languages
#**************************************************************************************************
# check and install clangd, make sure clang and llvm are already installed in the system
#if ! which clang; then
#   echo "installing clang"
#   sudo apt install clang
#else
#   echo "clang is already installed"
#fi


# set up clangd for C++, make sure llvm is already installed in the system
#if ! which clangd; then
#   echo "installing clangd"
#   curl -LO "https://github.com/clangd/clangd/releases/download/13.0.0/clangd-linux-13.0.0.zip"
#   unzip -n clangd-linux-13.0.0.zip -d "$HOME/.clangd"
#   # add path to bashrc file
#   echo "#Trung add below line" >> "$HOME/.bashrc"
#   echo "export PATH=\"$HOME/.clangd/clangd_13.0.0/bin:\$PATH\"" >> "$HOME/.bashrc"
#   echo "clangd is installed succesfully, after finishing the install, please run
#   source $HOME/.bashrc or reload the terminal so that the setting can be affected."
#else
#   echo "clangd is already installed"
#fi
#
# installing bear, which used to generate complile_commands.json file
#if ! which bear; then
#   echo "installing bear"
#   sudo apt install bear
#else
#   echo "bear is already installed"
#fi

# consider to also install shellcheck tool if you dev shell
# sudo apt install shellcheck
# other check tools if necessary
#**************************************************************************************************

# Copy and replace the current .vimrc
if [ -f "$HOME/.vimrc" ]; then
   while true; do
      read -rp "$HOME/.vimrc already exists, do you want to replace it? y/n" answer
      case $answer in
         [Yy]* ) cp "$(dirname "$0")/vimrc" "$HOME/.vimrc"; break;;
         [Nn]* ) break;;
         * ) echo "Please answer yes or no.";;
      esac
   done
else
   echo "copying predefined vimrc to ~/"
   cp vimrc "$HOME/.vimrc"
fi


# Add config so that nvim can use .vimrc configuration
nvim_dir="$HOME/.config/nvim"
if [ ! -d "$nvim_dir" ]; then
   echo "creating ~/.config/nvim dir..."
   mkdir -p "$nvim_dir"
else
   echo "$nvim_dir already exists"
fi

if [ -f "$HOME/.config/nvim/init.vim" ]; then
   while true; do
      read -rp "$nvim_dir/init.vim file already exists, do you want to replace it? y/n" answer
      case $answer in
         [Yy]* ) cp "$(dirname "$0")/init.vim" "$nvim_dir/init.vim"; break;;
         [Nn]* ) break;;
         * ) echo "Please answer yes or no.";;
      esac
   done
else
   echo "copying predefined init.vim to $nvim_dir"
   cp "$(dirname "$0")/init.vim" "$nvim_dir/init.vim"
fi


# Add configure language server file
# todo, use coc extension, so comment below code
#if [ -f "$HOME/.config/nvim/coc-settings.json" ]; then
#   while true; do
#      read -rp "$nvim_dir/coc-settings.json file already exists, do you want to replace it? y/n" answer
#      case $answer in
#         [Yy]* ) cp "$(dirname "$0")/coc-settings.json" "$nvim_dir/coc-settings.json"; break;;
#         [Nn]* ) break;;
#         * ) echo "Please answer yes or no.";;
#      esac
#   done
#else
#   echo "copying predefined coc-settings.json to $nvim_dir"
#   cp "$(dirname "$0")/coc-settings.json" "$nvim_dir/coc-settings.json"
#fi


# Add extension config files
if [ -f "$HOME/.config/nvim/coc.vim" ]; then
   while true; do
      read -rp "$nvim_dir/coc.vim file already exists, do you want to replace it? y/n" answer
      case $answer in
         [Yy]* ) cp "$(dirname "$0")/coc.vim" "$nvim_dir/coc.vim"; break;;
         [Nn]* ) break;;
         * ) echo "Please answer yes or no.";;
      esac
   done
else
   echo "copying predefined coc-settings.json to $nvim_dir"
   cp "$(dirname "$0")/coc.vim" "$nvim_dir/coc.vim"
fi
echo "finished installing all necessary things for vim, enjoy it..."


