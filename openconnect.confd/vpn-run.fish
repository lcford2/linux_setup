#!/bin/fish

source /home/lford/.config/fish/functions/vpn-up.fish
source /home/lford/.config/fish/functions/vpn-down.fish

trap vpn-down EXIT

vpn-up


