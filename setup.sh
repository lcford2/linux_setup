#!/bin/bash

EMACS_VERSION="28.2"
ZSH_VERSION="5.9"
NERDFONT_VERSION="2.2.2"

GREEN="\e[0;32m"
RED="\e[0;31m"
NC="\e[0m"

function print_header() {
    name=$1
    # width=70
    width="$(tput cols)"
    python_command="print('#'*${width})"
    hashes="$(python3 -c $python_command)"

    echo -e "${GREEN}${hashes}"
    echo $name | awk -v w=$width '{ z = w - length; y = int(z / 2); x = z - y; printf "%*s%s%*s\n", x, "", $0, y, ""; }'
    echo -e "${GREEN}${hashes}"
    echo -e "${NC}"
}

function pushd () {
    command pushd "$@" > /dev/null
}

function popd () {
    command popd "$@" > /dev/null
}

function safe_link () {
    target=$1
    link_name=$2
    
    if [ -e $link_name ]; then
        if [ -L $link_name ]; then
            echo "Cannot create link from $target to $link_name. $link_name is already a link"
        else
            echo "Cannot create link from $target to $link_name. $link_name exists but is not a link"
        fi
    else
        ln -sfv $target $link_name
    fi
}

#### ----------- system update ------------ ####
# update system and install curl
# download and install various programs
print_header "System Update"
sudo apt update && sudo apt upgrade
sudo apt install -y curl cmake build-essential gcp pbzip2 tk htop libssl-dev libsqlite3-dev openssl

#### ------- program configurations ------- ####
print_header "Create Computer Specific Program Configurations"
# create computer specific config files
cp fish/config.fish.base fish/config.fish
cp rofi/config.rasi.base rofi/config.rasi

#### ---------- directory setup ----------- ####
print_header "Setup Directories"
if ! [[ -d $HOME/source ]]; then
    mkdir -v $HOME/source
fi

if ! [[ -d $HOME/.config ]]; then
    mkdir -v $HOME/.config
fi

if ! [[ -d $HOME/projects ]]; then
    mkdir -v $HOME/projects
fi

if ! [[ -d $HOME/.local/bin ]]; then
    mkdir -vp $HOME/.local/bin
fi

if ! [[ -d $HOME/.fonts ]]; then
    mkdir -v $HOME/.fonts
fi

#### ------ link config directories ------- ####
print_header "Link Configuration Directores"
safe_link $HOME/linux_setup/alacritty $HOME/.config/alacritty
safe_link $HOME/linux_setup/helix     $HOME/.config/helix
safe_link $HOME/linux_setup/kitty     $HOME/.config/kitty
safe_link $HOME/linux_setup/qtile     $HOME/.config/qtile
safe_link $HOME/linux_setup/rofi      $HOME/.config/rofi
safe_link $HOME/linux_setup/htop      $HOME/.config/htop
safe_link $HOME/linux_setup/nvim      $HOME/.config/nvim

# link vim and doom directories (in $HOME)
safe_link $HOME/linux_setup/.doom.d    $HOME/.doom.d
safe_link $HOME/linux_setup/vimrc/.vim $HOME/.vim

# link starship.toml file
safe_link $HOME/linux_setup/misc_config/starship.toml $HOME/.config/starship.toml

# link git setup
safe_link $HOME/linux_setup/git/.gitconfig $HOME/.gitconfig
safe_link $HOME/linux_setup/git/.gitignore $HOME/.gitignore

# link zshrc
safe_link $HOME/linux_setup/zsh/.zshrc $HOME/.zshrc


#### --------------- rustup --------------- ####
print_header "Install Rustup"
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi


#### --------------- emacs ---------------- ####
print_header "Build Emacs $EMACS_VERSION"
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

# doom emacs
print_header "Install Doom Emacs"
if ! [ -d "$HOME/.emacs.d" ]; then
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
fi

#### ---------------- nvim ---------------- ####
print_header "Install NeoVim"
if ! command -v nvim &> /dev/null; then
    pushd $HOME/Downloads
    wget "https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb" -O "nvim-linux64.deb"
    sudo apt install -y ./nvim-linux64.deb
    popd
fi

#### -------------- vundle ---------------- ####
print_header "Install Vundle for NeoVim"
if [ "$(ls -A1 $HOME/.vim/bundle/Vundle.vim | wc -l)" -eq 0 ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

#### ---------- modern utilities ---------- ####
print_header "Install Modern Linux Utilities"
CARGO=$HOME/.cargo/bin/cargo

$CARGO install --locked bat
$CARGO install git-delta
$CARGO install du-dust
$CARGO install exa
$CARGO install fd-find
$CARGO install mcfly
$CARGO install procs
$CARGO install --locked starship
$CARGO install ripgrep

#### --------------- kitty ---------------- ####
print_header "Install Kitty"
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
print_header "Install NerdFonts"
pushd $HOME/Downloads
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/DejaVuSansMono.zip" -O "DejaVuSansMono.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/UbuntuMono.zip" -O "UbuntuMono.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/Ubuntu.zip" -O "Ubuntu.zip"
unzip -u DejaVuSansMono.zip
unzip -u UbuntuMono.zip
unzip -u Ubuntu.zip

mv *.ttf $HOME/.fonts
sudo fc-cache -f -v


#### ---------------- zsh ----------------- ####
print_header "Install and Configure ZSH"
if ! command -v zsh &> /dev/null; then
    pushd $HOME/source
    wget "https://gigenet.dl.sourceforge.net/project/zsh/zsh/$ZSH_VERSION/zsh-$ZSH_VERSION.tar.xz" -O "zsh-$ZSH_VERSION.tar.xz"
    tar xf zsh-$ZSH_VERSION.tar.xz
    cd zsh-$ZSH_VERSION
    ./configure && make && sudo make install
    popd
fi

# zsh autosuggestions
pushd ~/source
if ! [ -d zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
else
    cd zsh-syntax-highlighting
    git pull
    cd ..
fi
if ! [ -d zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git
else
    cd zsh-autosuggestions
    git pull
    cd ..
fi
popd

# history file
if ! [ -f $HOME/.zshhistory ]; then
    touch $HOME/.zshhistory
fi

# add zsh to shells
if [ "$(/bin/grep "/usr/local/bin/zsh" /etc/shells -c)" -eq 0 ]; then
    echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
fi


#### --------------- pyenv ---------------- ####
print_header "Install pyenv"
if ! [[ -d $HOME/.pyenv ]]; then
    git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
    pushd $HOME/.pyenv
    src/configure && make -C src
    popd
fi

#### --------------- conda ---------------- ####
print_header "Install Miniconda"
if ! command -v conda &> /dev/null; then
    cd $HOME/Downloads
    MINICONDA_FILE="Miniconda3-latest-Linux-x86_64.sh"
    wget "https://repo.anaconda.com/miniconda/$MINICONDA_FILE" -O $MINICONDA_FILE
    sh $MINICONDA_FILE -b -p $HOME/miniconda3
    $HOME/miniconda3/condabin/conda init
    popd
fi
