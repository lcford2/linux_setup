#!/bin/bash

source ./helpers/utils.sh

DEFAULT_NVM_VERSION="v0.39.7"

if [ -n "$NVM_VERSION" ]; then
  echo "${RED}NVM_VERSION not specified, using ${DEFAULT_NVM_VERSION}${NC}"
  export NVM_VERSION="$DEFAULT_NVM_VERSION"
fi

# install nvm for neovim plugins
print_header "Installing Node for neovim LSPs"
nvm_install_output=$(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash)
nvm_dir_cmd=$(echo "$nvm_install_output" | grep -oP "export NVM_DIR=\H*")
eval "$nvm_dir_cmd"
if [ -n "$NVM_DIR" ]; then
  source "$NVM_DIR/nvm.sh"
  nvm install node >/dev/null 2>&1
else
  echo "Could not install node with nvm."
fi
