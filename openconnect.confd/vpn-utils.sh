#!/bin/bash

function vpn-up () {
  sudo openvpn --mktun --dev tun1
  sudo ifconfig tun1 up
  # password="$(cat ${HOME}/.secrets/ncsu.password)"
  password="$(openssl enc -d -in ${HOME}/.secrets/ncsu.password.enc -aes-256-cbc -pbkdf2)"
  # echo $password
  echo $password | sudo openconnect --protocol=anyconnect vpn.ncsu.edu --config="${HOME}/.secrets/ncsu.conf" --passwd-on-stdin
}

function vpn-down () {
  sudo ifconfig tun1 down
  sudo ip link delete tun1
}

trap vpn-down EXIT

vpn-up
