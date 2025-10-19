#!/bin/bash

source helpers/utils.sh

print_header "Install NerdFonts"
mkdir -p /tmp/font_install
quiet_pushd "/tmp/font_install" || exit
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/DejaVuSansMono.zip" -O "DejaVuSansMono.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/UbuntuMono.zip" -O "UbuntuMono.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/Ubuntu.zip" -O "Ubuntu.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/Hack.zip" -O "Hack.zip"

quiet_popd || exit
quiet_pushd "$HOME/.fonts"

unzip -u /tmp/font_install/DejaVuSansMono.zip
unzip -u /tmp/font_install/UbuntuMono.zip
unzip -u /tmp/font_install/Ubuntu.zip
unzip -u /tmp/font_install/Hack.zip

fc-cache -f -v
quiet_popd || exit
