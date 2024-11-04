#!/usr/bin/env bash

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
rm -rf ~/nvim-linux64
tar -C ~ -xzf nvim-linux64.tar.gz

read -p "Do you want to proceed adding nvim to your bashrc file? (Y/n): " answer
if [[ $(echo "$answer" | tr '[:upper:]' '[:lower:]') == 'y' ]]; then
  echo "export PATH=$PATH:~/nvim-linux64/bin" >> ~/.bashrc
  echo "alias vim=nvim" >> ~/.bashrc
  echo "alias vi=nvim" >> ~/.bashrc
  source ~/.bashrc
fi

