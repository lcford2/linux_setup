#!/bin/fish

function vpn-up
    sudo openvpn --mktun --dev tun1
    sudo ifconfig tun1 up
    #sudo openconnect vpn.ncsu.edu --background --user=lcford2 --authgroup=2-Student --interface=tun1
    sudo openconnect vpn.ncsu.edu --config=/home/lford/admin/openconnect.confd/ncsu.conf
end
