#!/bin/bash

export GREEN="\e[0;32m"
export RED="\e[0;31m"
export NC="\e[0m"

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

function quiet_pushd() {
  command pushd "$@" >/dev/null || exit
}

function quiet_popd() {
  command popd >/dev/null || exit
}
