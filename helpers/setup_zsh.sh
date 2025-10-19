#!/bin/bash

source ./helpers/utils.sh

print_header "Setting up ZSH"
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 --keep
chsh -s $(which zsh) "$USER"
