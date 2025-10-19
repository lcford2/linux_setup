#!/bin/bash

source ./helpers/utils.sh

print_header "Install Modern Linux Utilities"
# fzf install
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# cargo utils install
CARGO=$HOME/.cargo/bin/cargo

$CARGO install cargo-update
$CARGO install --locked bat
$CARGO install git-delta
$CARGO install du-dust
$CARGO install eza
$CARGO install fd-find
$CARGO install procs
$CARGO install ripgrep
$CARGO install starship --locked
$CARGO install zoxide --locked
$CARGO install tealdeer
$CARGO install alacritty
