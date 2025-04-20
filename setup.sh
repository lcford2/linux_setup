#!/bin/bash

NERDFONT_VERSION="2.2.2"

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

#### ---------- Install Homebrew ---------- ####
print_header "Install Homebrew"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

print_header "Install Packages with brew"
brew install google-chrome visual-studio-code neovim htop rectangle

#### ------- program configurations ------- ####
print_header "Create Computer Specific Program Configurations"
# create computer specific config files
cp fish/config.fish.base fish/config.fish
cp rofi/config.rasi.base rofi/config.rasi

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

#### ------ link config directories ------- ####
print_header "Link Configuration Directores"
stow -R -t ../. dotfiles -v 3

# link script to .local/bin
for file in $(/bin/ls "$HOME"/linux_setup/scripts/); do
  ln -sf "$HOME/linux_setup/scripts/$file" "$home/.local/bin/$file"
done

#### --------------- rustup --------------- ####
print_header "Install Rustup"
# if ! command -v rustup &> /dev/null || [ "$UPDATE" -eq 1 ]; then
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# fi

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
fi

#### --------------- fonts ---------------- ####
print_header "Install NerdFonts"
pushd "$HOME/Downloads" || exit
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/DejaVuSansMono.zip" -O "DejaVuSansMono.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/UbuntuMono.zip" -O "UbuntuMono.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONT_VERSION/Ubuntu.zip" -O "Ubuntu.zip"
unzip -u DejaVuSansMono.zip
unzip -u UbuntuMono.zip
unzip -u Ubuntu.zip

mv "*.ttf" "$HOME/.fonts"
sudo fc-cache -f -v
popd || exit
