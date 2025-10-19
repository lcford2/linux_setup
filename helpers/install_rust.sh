#!/bin/bash

source ./helpers/utils.sh

print_header "Install Rustup"
if ! command -v rustup &> /dev/null || [ "$UPDATE" -eq 1 ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
