#!/bin/bash

NERDFONT_VERSION="3.4.0"
NVM_VERSION="v0.39.7"

source helpers/utils.sh

function show_help() {
  cat << EOF
Usage: $0 [OPTIONS]

Options:
  -h, --help               Show this help message
  -U, --update             Update existing packages
  -v, --verbose            Show detailed output
  --skip-ssh-server        Do not enable the SSH server
  --skip-brew              Skip Homebrew installation
  --skip-node              Skip Node/NVM installation
  --skip-rust              Skip Rustup installation
  --skip-fonts             Skip NerdFonts installation
  --skip-tmux              Skip TPM installation
  --skip-tailscale         Skip Tailscale installation
  --skip-modern-utils      Skip modern utilities installation
  --nvm-version=VERSION    NVM version to install (default: $NVM_VERSION)

Examples:
  $0 --skip-tailscale --skip-fonts
  $0 --update --nvm-version=v0.40.0
  $0 --skip-brew --skip-node
EOF
}

function parse_args() {
  export UPDATE=0
  export SKIP_SSH_ENABLE=0
  export SKIP_BREW=0
  export SKIP_NODE=0
  export SKIP_RUST=0
  export SKIP_FONTS=0
  export SKIP_TMUX=0
  export SKIP_TAILSCALE=0
  export SKIP_MODERN_UTILS=0
  export VERBOSE=0

  while test $# -gt 0; do
    case "$1" in
    -h|--help)
      show_help
      exit 0
      ;;
    -U | --update)
      echo "Updating packages if existing"
      export UPDATE=1
      ;;
    -v|--verbose)
      export VERBOSE=1
      ;;
    --skip-ssh-server)
      export SKIP_SSH_ENABLE=1
      ;;
    --skip-brew)
      export SKIP_BREW=1
      ;;
    --skip-node)
      export SKIP_NODE=1
      ;;
    --skip-rust)
      export SKIP_RUST=1
      ;;
    --skip-fonts)
      export SKIP_FONTS=1
      ;;
    --skip-tmux)
      export SKIP_TMUX=1
      ;;
    --skip-tailscale)
      export SKIP_TAILSCALE=1
      ;;
    --skip-modern-utils)
      export SKIP_MODERN_UTILS=1
      ;;
    --nvm-version=*)
      export NVM_VERSION="${1#*=}"
      ;;
    *)
      echo "Unknown option: $1"
      show_help
      exit 1
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
  software-properties-common \
	curl \
	cmake \
	build-essential \
  openssh-server \
  bmon \
  nethogs \
  nmon \
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
  htop \
	python3 \
	python3-pip \
	python3-venv \
  gnome-tweaks

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


#### --------- Enable SSH Server ---------- ####
if [ "$SKIP_SSH_ENABLE" -eq 0 ]; then
  print_header "Enabling SSH Server"
  sudo systemctl enable --now ssh
fi

#### ---------- Install Homebrew ---------- ####
if [ "$SKIP_BREW" -eq 0 ]; then
  ./helpers/install_brew.sh
fi

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
  cat ./helpers/bash_additions.sh >> "${HOME}/.bashrc"
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
if [ "$SKIP_NODE" -eq 0 ]; then
  ./helpers/install_node.sh
fi

#### --------------- rustup --------------- ####
if [ "$SKIP_RUST" -eq 0 ]; then
  ./helpers/install_rust.sh
fi

#### ---------- modern utilities ---------- ####
if [ "$SKIP_MODERN_UTILS" -eq 0 ]; then
  ./helpers/install_modern_utils.sh
fi

#### ---------------- zsh setup ---------------- ####
./helpers/setup_zsh.sh


#### --------------- fonts ---------------- ####
if [ "$SKIP_FONTS" -eq 0 ]; then
  ./helpers/install_fonts.sh
fi


#### --------------- tmux ------------------ ####
if [ "$SKIP_TMUX" -eq 0 ]; then
  # tmux package manager
  print_header "Installing TPM"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

#### ------------- Tailscale --------------- ####
if [ "$SKIP_TAILSCALE" -eq 0 ]; then
  # Tailscale
  print_header "Installing Tailscale"
  curl -fsSL https://tailscale.com/install.sh | sh
fi
