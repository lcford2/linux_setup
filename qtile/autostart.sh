#!/bin/sh


# nitrogen for wallpaper
nitrogen --restore &
# picom for compositing apps
picom &
# light-locker to lock screen when away
light-locker &

# systray battery icon
cbatticon -u 5 &
# systray volume
volumeicon &
