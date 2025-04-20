#!/bin/bash

# ubuntu deps ninja-build gettext cmake unzip curl git gcc
# macos xcode-select --install, brew, ninja, cmake, gettext, curl

LATEST_RELEASE=v0.1.0

NVIM_MAJOR_TARGET=10
NVIM_MINOR_TARGET=0
VERSION="v0.${NVIM_MAJOR_TARGET}.${NVIM_MINOR_TARGET}"
BASE_URL="https://github.com/neovim/neovim/releases/download/${VERSION}"

ARCH=$(uname -m)
OS=$(uname)

if [ -z "${NVIM_PREFIX}" ]; then
  NVIM_PREFIX=/usr/local
fi

if command -v sudo &>/dev/null; then
  SUDO_STR="sudo "
  echo "Will use 'sudo' to install packages where needed."
else
  SUDO_STR=""
fi

INSTALL=1
PROMPT=1
UPGRADE=0

usage () {
  echo "usage:"
  echo "./install.sh [-h|--help] [-n|--no-install] [-U|--upgrade]"
  echo "Arguments:"
  echo "    -h|--help:       Display this help message and quit."
  echo "    -n|--no-install: Do not attempt to install neovim"
  echo "                     User must have neovim installed already"
  echo "    -U|--upgrade:    Upgrade Neovim to latest version."
}

neovim_install_help() {
  echo "See https://github.com/neovim/neovim/blob/master/INSTALL.md"
  echo "for installation instructions."
}

_install_deps_apt () {
  echo "Installing Neovim Dependencies"
  # Use APT to install the build dependencies for neovim
  ${SUDO_STR}apt update &>/dev/null && ${SUDO_STR}apt install -y \
    curl \
    git \
    python3-venv \
    python3-pip \
    clang &>/dev/null
}

_install_build_deps_apt () {
  # Use APT to install the build dependencies for neovim
  ${SUDO_STR}apt update &>/dev/null && ${SUDO_STR}apt install -y \
    build-essential \
    cmake \
    gettext \
    unzip &>/dev/null
}

_install_binary () {
  # Download and install prebuilt binaries
  echo "Installing from pre-compiled binary"
  # ensure an argument was passed
  if [ $# -lt 1 ]; then
    echo "Must provide binary name."
    exit 3
  fi
  # download neovim binaries
  binary_name="$1"
  URL="${BASE_URL}/${binary_name}.tar.gz"
  curl -sOL "$URL"
  # extract and install neovim components
  tar xf "${binary_name}.tar.gz"
  sudo mkdir -p "${NVIM_PREFIX}/{bin,share,lib}"
  sudo cp -r "${binary_name}/bin/nvim" "${NVIM_PREFIX}/bin/nvim"
  sudo cp -r "${binary_name}/share/"* "${NVIM_PREFIX}/share"
  sudo cp -r "${binary_name}/lib/"* "${NVIM_PREFIX}/lib"
  rm -rf "./${binary_name}" "./${binary_name}.tar.gz"
}

_install_source () {
  echo "Building neovim from source" 
  # install build dependencies
  if ! command -v apt &>/dev/null; then
    echo "Cannot install neovim build deps using apt (apt not found)"
    exit 4
  fi
  _install_build_deps_apt
  # download and extract target release
  curl -sOL "https://github.com/neovim/neovim/archive/refs/tags/${VERSION}.tar.gz"
  tar xf "${VERSION}.tar.gz"
  cd "neovim-0.${NVIM_MAJOR_TARGET}.${NVIM_MINOR_TARGET}" || exit 2
  # build neovim and install
  make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_NVIM_PREFIX=$NVIM_PREFIX"
  make install || \
    echo "ERROR: Could not run 'make install' for neovim." \
         " This is likely due to permission errors. Try running " \
         " with sudo."
}

_install_node () {
  # install nodejs for lsps
  echo "Installing Node to neovim LSPs"
  nvm_install_output=$(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash)
  nvm_dir_cmd=$(echo "$nvm_install_output" | grep -oP "export NVM_DIR=\H*")
  eval "$nvm_dir_cmd"
  if [ -n "$NVM_DIR" ]; then
    source "$NVM_DIR/nvm.sh"
    nvm install node >/dev/null 2>&1
  else
    echo "Could not install node with nvm."
  fi
}

install_nvim () {
  _install_deps_apt
  if [ "${OS}" == "Linux" ]; then
    if [ "${ARCH}" != "x86_64" ]; then
      # Install neovim from source since no precompiled binaries exist
      _install_source
    else 
      # Install neovim from latest stable release
      _install_binary "nvim-linux64"
    fi
  elif [ "${OS}" == "Darwin" ]; then
    if command -v brew &>/dev/null; then
      # prefer brew install 
      brew install neovim
    else
      # if no brew, download binaries and install them
      _install_binary "nvim-macos"
    fi
  fi
  _install_node
}

# parse command line arguments
while test $# -gt 0; do
  case "$1" in
    -n|--no-install)
      echo "Not attempting to install neovim"
      INSTALL=0
      ;;
    -U|--upgrade)
      echo "Upgrading neovim."
      UPGRADE=1
      ;;
    --no-prompt)
      echo "Not prompting during installation"
      PROMPT=0
      ;;
    -h|--help)
      usage
      exit 0
      ;;
  esac
  shift
done

printf "\n==================================================\n"
echo "Installing with configuration:"
echo "Neovim Version: $VERSION"
echo "ARCH: ${ARCH}"
echo "OS: ${OS}"
echo "NVIM_PREFIX: ${NVIM_PREFIX}"
printf "==================================================\n\n"

if [ "${PROMPT}" == 1 ]; then
  read -rp "Continue? [y/N] " INPUT
  if [ "${INPUT}" != "y" ] && [ "${INPUT}" != "Y" ]; then
    echo "Exiting..."
    exit 4
  fi
fi

# If neovim is not found, download it
if ! command -v nvim &> /dev/null; then
  if [ "$INSTALL" == 0 ]; then
    echo "Neovim was not found and no install attempt was made."
    echo "Please install neovim with your preferred method."
    neovim_install_help
    exit 1
  fi
  install_nvim 
fi

# ensure the XDG_CONFIG_HOME variable is set
if [ -z "$XDG_CONFIG_HOME" ]; then
  mkdir -p ~/.config
  XDG_CONFIG_HOME="${HOME}/.config"
fi

NEOVIM_CONFIG_DIR="${XDG_CONFIG_HOME}/nvim"
# backup old neovim settings
if [ -d "${NEOVIM_CONFIG_DIR}" ]; then
  mv "${NEOVIM_CONFIG_DIR}" "${NEOVIM_CONFIG_DIR}.bkp"
fi

# get neovim configuration
echo "Setting up custom neovim config at ${NEOVIM_CONFIG_DIR}"
curl -sOL "https://github.com/lcford2/nvim/archive/refs/tags/${LATEST_RELEASE}.tar.gz"
tar xf "${LATEST_RELEASE}.tar.gz"
mv "nvim-${LATEST_RELEASE//v}" "${NEOVIM_CONFIG_DIR}"
rm "${LATEST_RELEASE}.tar.gz"

# echo out instruction message for user
printf "\n==================================================\n"
echo "Installation Complete!!"
echo "Close and reopen your terminal, then run 'nvim'."
echo "Your plugins will install, and you may need to close and reopen neovim afterwards."
printf "==================================================\n\n"
