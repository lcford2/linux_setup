#!/bin/bash

EMACS_VERSION="28.2"


#### ----------- system update ------------ ####
# update system and install curl
# download and install various programs
sudo apt install -y curl cmake build-essential

#### ------- program configurations ------- ####
# create computer specific config files
cp fish/config.fish.base fish/config.fish
cp rofi/config.rasi.base rofi/config.rasi

#### ---------- directory setup ----------- ####
if ! [[ -d $HOME/source ]]; then
    mkdir $HOME/source
fi

if ! [[ -d $HOME/.config ]]; then
    mkdir $HOME/.config
fi

if ! [[ -d $HOME/projects ]]; then
    mkdir $HOME/projects
fi

if ! [[ -d $HOME/.local ]]; then
    mkdir $HOME/.local
fi

if ! [[ -d $HOME/.fonts ]]; then
    mkdir $HOME/.fonts
fi

#### ------ link config directories ------- ####
ln -sf $HOME/linux_setup/alacritty $HOME/.config/alacritty
ln -sf $HOME/linux_setup/helix     $HOME/.config/helix
ln -sf $HOME/linux_setup/kitty     $HOME/.config/kitty
ln -sf $HOME/linux_setup/qtile     $HOME/.config/qtile
ln -sf $HOME/linux_setup/rofi      $HOME/.config/rofi
ln -sf $HOME/linux_setup/htop      $HOME/.config/htop
ln -sf $HOME/linux_setup/nvim      $HOME/.config/nvim

# link vim and doom directories (in $HOME)
ln -sf $HOME/linux_setup/.doom.d    $HOME/.doom.d
ln -sf $HOME/linux_setup/vimrc/.vim $HOME/.vim

# link starship.toml file
ln -sf $HOME/linux_setup/misc_config/startship.toml $HOME/.config/starship.toml

# link git setup
ln -sf $HOME/linux_setup/git/.gitconfig $HOME/.gitconfig
ln -sf $HOME/linux_setup/git/.gitignore $HOME/.gitignore


#### --------------- rustup --------------- ####
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

#### --------------- pyenv ---------------- ####
if ! [[ -d $HOME/.pyenv ]]; then
    git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
    pushd $HOME/.pyenv
    src/configure && make -C src
    popd
fi

#### --------------- emacs ---------------- ####
# build deps
sudo apt build-dep -y emacs
sudo apt install -y libgccjit0 libgccjit-10-dev libjansson4 libjansson-dev gnutls-bin
# get emacs
if ! command -v emacs &> /dev/null; then
    pushd $HOME/source
    curl -O "https://ftp.gnu.org/pub/gnu/emacs/emacs-${EMACS_VERSION}.tar.xz"
    tar xf emacs-$EMACS_VERSION.tar.xz
    # build emacs
    cd emacs-$EMACS_VERSION
    ./configure
    make -j 4
    sudo make install
    popd
fi

#### ---------------- nvim ---------------- ####
if ! command -v nvim &> /dev/null; then
    pushd $HOME/Downloads
    wget "https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb"
    sudo apt install -y ./nvim-linux64.deb
    popd
fi

#### ---------- modern utilities ---------- ####
CARGO=$HOME/.cargo/bin/cargo

$CARGO install --locked bat
$CARGO install git-delta
$CARGO install du-dust
$CARGO install exa
$CARGO install fd-find
$CARGO install mcfly
$CARGO install procs
$CARGO install --locked starship

#### --------------- kitty ---------------- ####
if ! command -v kitty &> /dev/null; then
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    # Create a symbolic link to add kitty to PATH (assuming ~/.local/bin is in
    # your system-wide PATH)
    ln -sf $HOME/.local/kitty.app/bin/kitty $HOME/.local/bin/
    # Place the kitty.desktop file somewhere it can be found by the OS
    cp $HOME/.local/kitty.app/share/applications/kitty.desktop $HOME/.local/share/applications/
    # If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
    cp $HOME/.local/kitty.app/share/applications/kitty-open.desktop $HOME/.local/share/applications/
    # Update the paths to the kitty and its icon in the kitty.desktop file(s)
    sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" $HOME/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" $HOME/.local/share/applications/kitty*.desktop
fi

#### --------------- fonts ---------------- ####
pushd $HOME/Downloads
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/DejaVuSansMono.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/UbuntuMono.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Ubuntu.zip"
unzip DejaVuSansMono.zip
unzip UbuntuMono.zip
unzip Ubuntu.zip

mv *.ttf $HOME/.fonts
sudo fc-cache -f -v

#### -------------- vundle ---------------- ####
if ! [ $(ls -A $HOME/.vim/bundle/Vundle.vim) ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
