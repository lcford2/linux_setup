#!/bin/sh

ndisplays=$(xrandr | grep " connected" | wc -l)

if [ $ndisplays -eq 2 ]; then
    echo "2 displays" >> "/home/lford/.config/qtile/xorg.log"
    xrandr --output eDP-1 --mode 1920x1080 \
           --output DP-1 --pos 1920x0 --panning 1920x1080+1920+0 \
           --output DP-2-1 --pos 1920x0 --panning 1920x1080+1920+0 \
           --output DP-2-2 --pos 1920x0 --panning 1920x1080+1920+0
    sed -i 's/font: "DejaVuSansMono Nerd Font [0-9][0-9]"/font: "DejaVuSansMono Nerd Font 16"/' $HOME/.config/rofi/config.rasi
elif [ $ndisplays -eq 3 ]; then
    echo "3 displays" >> "/home/lford/.config/qtile/xorg.log"
    xrandr --output DP-2-3 --mode 1920x1080 \
           --output DP-2-2 --panning 1920x1080+1920+0 --right-of DP-2-3 \
           --output eDP-1 --mode 1920x1080 --panning 1920x1080+3840+0 --right-of DP-2-2
    sed -i 's/font: "DejaVuSansMono Nerd Font [0-9][0-9]"/font: "DejaVuSansMono Nerd Font 16"/' $HOME/.config/rofi/config.rasi
else
    echo "1 display" >> "/home/lford/.config/qtile/xorg.log"
    xrandr --output eDP-1 --mode 3840x2160
    sed -i 's/font: "DejaVuSansMono Nerd Font [0-9][0-9]"/font: "DejaVuSansMono Nerd Font 26"/' $HOME/.config/rofi/config.rasi
    # xrandr --output eDP-1 --mode 1920x1080
fi

# nitrogen for wallpaper
nitrogen --restore &
# picom for compositing apps
picom &
# light-locker to lock screen when away
# light-locker &

# systray battery icon
cbatticon -u 5 &
# systray volume
volumeicon &

# start emacs daemon
emacs --daemon

# start playerctl
playerctld daemon
