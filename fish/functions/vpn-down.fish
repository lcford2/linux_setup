#!/bin/fish

function vpn-down
    #set pid eval pgrep openconnect
    #sudo kill $pid
    sudo ifconfig tun1 down
    sudo ip link delete tun1
end

