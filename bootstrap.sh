#!/usr/bin/env bash

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# install nvim 0.10
curl https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz -0
tar xzvf nvim-linux64.tar.gz
echo "export PATH=$PATH:~/nvim-linux64/bin" >> ~/.bashrc
source ~/.bashrc

