#!/usr/bin/env bash

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
rm -rf ~/nvim-linux64
tar -C ~ -xzf nvim-linux64.tar.gz

read -p "Do you want to add nvim as editor to your .bashrc? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "export PATH=$PATH:~/nvim-linux64/bin" >> ~/.bashrc
  echo "alias vim=nvim" >> ~/.bashrc
  echo "alias vi=nvim" >> ~/.bashrc
  source ~/.bashrc
fi

