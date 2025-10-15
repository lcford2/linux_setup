#!/bin/bash

NERDFONT_VERSION="3.4.0"

GREEN="\e[0;32m"
RED="\e[0;31m"
NC="\e[0m"

function print_header() {
  name=$1
  # width=70
  width="$(tput cols)"
  python_command="print('#'*${width})"
  hashes="$(python3 -c "$python_command")"

  echo -e "${GREEN}${hashes}"
  echo "$name" | awk -v w="$width" '{ z = w - length; y = int(z / 2); x = z - y; printf "%*s%s%*s\n", x, "", $0, y, ""; }'
  echo -e "${GREEN}${hashes}"
  echo -e "${NC}"
}

function pushd() {
  command pushd "$@" >/dev/null || exit
}

function popd() {
  command popd >/dev/null || exit
}

function parse_args() {
  export UPDATE=0
  while test $# -gt 0; do
    case "$1" in
    -U | --update)
      echo "Updating packages if existing"
      export UPDATE=1
      ;;
    esac
    shift
  done
}

parse_args "$@"

#### ---------- System Update and Base Pkg Install ---------- ####
print_header "System Update"
sudo apt update && sudo apt upgrade
sudo apt install -y \
	curl \
	cmake \
	build-essential \
	gcp \
	pbzip2 \
	htop \
	libssl-dev \
	libsqlite3-dev \
	openssl \
	cifs-utils \
	smbclient \
	libreadline8 \
	libreadline-dev \
	tk \
	tk-dev \
	stow \
	gnome-tweaks \
	gdb \
	zsh \
	git \
	unzip \
	python3 \
	python3-pip \
	python3-venv

#### ------------ Repo Hygiene ------------ ####
print_header "Repo Hygiene"
git submodule update --init --recursive
git config submodule.recurse true

#### ---------- directory setup ----------- ####
print_header "Setup Directories"
if ! [[ -d "$HOME/source" ]]; then
  mkdir -v "$HOME/source"
fi

if ! [[ -d "$HOME/.config" ]]; then
  mkdir -v "$HOME/.config"
fi

if ! [[ -d "$HOME/projects" ]]; then
  mkdir -v "$HOME/projects"
fi

if ! [[ -d "$HOME/.local/bin" ]]; then
  mkdir -vp "$HOME/.local/bin"
fi

if ! [[ -d "$HOME/.fonts" ]]; then
  mkdir -v "$HOME/.fonts"
fi

#### ---------- Install Homebrew ---------- ####
print_header "Install Homebrew"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

print_header "Install Packages with brew"
/home/linuxbrew/.linuxbrew/bin/brew install neovim htop jq tmux

#### ------- program configurations ------- ####
print_header "Create Computer Specific Program Configurations"
# create computer specific config files
pushd dotfiles/.config || exit
cp fish/config.fish.base fish/config.fish
cp rofi/config.rasi.base rofi/config.rasi
popd || exit

#### ------ link config directories ------- ####
print_header "Link Configuration Directores"
if [ -f "$HOME/.bashrc" ]; then
  mv "$HOME/.bashrc" "$HOME/.bashrc.bkp"
fi
if [ -f "$HOME/.zshrc" ]; then
  mv "$HOME/.zshrc" "$HOME/.bashrc.bkp"
fi
stow -R -t ../. dotfiles -v 3

# link script to .local/bin
for file in $(/bin/ls "$HOME"/linux_setup/scripts/); do
  ln -sf "$HOME/linux_setup/scripts/$file" "$HOME/.local/bin/$file"
done

#### ---------------- node ---------------- ####
# install nvm for neovim plugins
print_header "Installing Node for neovim LSPs"
nvm_install_output=$(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash)
nvm_dir_cmd=$(echo "$nvm_install_output" | grep -oP "export NVM_DIR=\H*")
eval "$nvm_dir_cmd"
if [ -n "$NVM_DIR" ]; then
	source "$NVM_DIR/nvm.sh"
	nvm install node >/dev/null 2>&1
else
	echo "Could not install node with nvm."
fi

#### --------------- rustup --------------- ####
print_header "Install Rustup"
if ! command -v rustup &> /dev/null || [ "$UPDATE" -eq 1 ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

#### ---------------- zsh setup ---------------- ####
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 --keep
chsh -s $(which zsh) $(whoami)


#### ---------- modern utilities ---------- ####
print_header "Install Modern Linux Utilities"
CARGO=$HOME/.cargo/bin/cargo

if [ "$UPDATE" -eq 1 ]; then
  cargo install-update -a
else
  $CARGO install cargo-update
  $CARGO install --locked bat
  $CARGO install git-delta
  $CARGO install du-dust
  $CARGO install eza
  $CARGO install fd-find
  $CARGO install mcfly
  $CARGO install procs
  $CARGO install ripgrep
  $CARGO install starship --locked
  $CARGO install zoxide --locked
fi

#### --------------- fonts ---------------- ####
print_header "Install NerdFonts"
mkdir -p /tmp/font_install
pushd "/tmp/font_install" || exit
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/DejaVuSansMono.zip" -O "DejaVuSansMono.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/UbuntuMono.zip" -O "UbuntuMono.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/Ubuntu.zip" -O "Ubuntu.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/Hack.zip" -O "Hack.zip"

popd || exit
pushd "$HOME/.fonts"

unzip -u /tmp/font_install/DejaVuSansMono.zip
unzip -u /tmp/font_install/UbuntuMono.zip
unzip -u /tmp/font_install/Ubuntu.zip
unzip -u /tmp/font_install/Hack.zip

fc-cache -f -v
popd || exit


#### --------------- tmux ------------------ ####
# tmux package manager
print_header "Installing TPM"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
