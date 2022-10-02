#!/bin/bash

# create computer specific config files
cp fish/config.fish.base fish/config.fish
cp rofi/config.rasi.base rofi/config.rasi

# make sure .config exists

if ! [[ -d $HOME/.config ]]; then
  mkdir $HOME/.config
fi

# link configuration directories
ln -sf $HOME/linux_setup/alacritty $HOME/.config/alacritty
ln -sf $HOME/linux_setup/helix     $HOME/.config/helix
ln -sf $HOME/linux_setup/kitty     $HOME/.config/kitty
ln -sf $HOME/linux_setup/qtile     $HOME/.config/qtile
ln -sf $HOME/linux_setup/rofi      $HOME/.config/rofi
ln -sf $HOME/linux_setup/htop      $HOME/.config/htop

# link vim and doom directories (in $HOME)
ln -sf $HOME/linux_setup/.doom.d    $HOME/.doom.d
ln -sf $HOME/linux_setup/vimrc/.vim $HOME/.vim

# link starship.toml file
ln -sf $HOME/linux_setup/misc_config/startship.toml $HOME/.config/starship.toml


