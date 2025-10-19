#!/bin/bash

source helpers/utils.sh

print_header "Install Homebrew"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

print_header "Install Packages with brew"
/home/linuxbrew/.linuxbrew/bin/brew install neovim htop jq tmux
