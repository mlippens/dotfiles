#!/usr/bin/env bash

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
if [[ -f ~/nvim-linux64 ]]; then
  echo "Removing previous installation..."
  rm -rf ~/nvim-linux64
fi
tar -C ~ -xzf nvim-linux64.tar.gz

read -p "Do you want to proceed adding nvim to your bashrc file? (Y/n): " answer
if [[ $(echo "$answer" | tr '[:upper:]' '[:lower:]') == 'y' ]]; then
  if grep -q "nvim-preblock" ~/.bashrc;
  then
    echo "nvim path and aliases already configured!"
    exit 0
  fi
  echo "# nvim-preblock" >> ~/.bashrc
  echo "export PATH=\$PATH:~/nvim-linux64/bin" >> ~/.bashrc
  echo "alias vim=nvim" >> ~/.bashrc
  echo "alias vi=nvim" >> ~/.bashrc
  source ~/.bashrc
fi

