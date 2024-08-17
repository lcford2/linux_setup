#!/bin/bash

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


# install required packages for calc nvim
print_header "Installing Python Packages"
python3 -m pip install asteval pynvim

# install venv for nvim packages
print_header "Installing APT Packages"
sudo apt update && sudo apt install python3-venv git -y 

# get my nvim config
print_header "Installing Neovim"
if [ -d "${HOME}/.config/nvim" ]; then
	mv "${HOME}/.config/nvim" "${HOME}/.config/nvim.bkp"
fi

mkdir -p "${HOME}/.config"
git clone https://github.com/lcford2/nvim.git ${HOME}/.config/nvim

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

# get my tmux config
print_header "Installing tmux and TPM"
git clone https://github.com/lcford2/tmux.git ${HOME}/.config/tmux

# get TPM for tmux
git clone https://github.com/tmux-plugins/tpm ~/.tpm/plugins/tpm

# change ps1
print_header "Changing Prompt"
echo 'export PS1="[\e[0;34m\u@\h \e[0m\e[0;32m\@\e[0m] \w\n$ "' >> ~/.bashrc
