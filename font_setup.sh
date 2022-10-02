#!/bin/bash

ndisplays=$(xrandr | grep ' connected' | wc -l)
hres=$(xrandr | grep ' connected' | grep -P ' [0-9]{4}x' -o | awk '{print substr($0, 1, 5)}')

if [ $ndisplays -eq 1 ]; then
  sed -i 's/font: "DejaVuSansMono Nerd Font [0-9][0-9]"/font: "DejaVuSansMono Nerd Font 26"/' $HOME/.config/rofi/config.rasi
  sed -i 's/Xft\.dpi:.*/Xft.dpi: 192/' $HOME/.Xresources
else
  sed -i 's/font: "DejaVuSansMono Nerd Font [0-9][0-9]"/font: "DejaVuSansMono Nerd Font 16"/' $HOME/.config/rofi/config.rasi
  sed -i 's/Xft\.dpi:.*/Xft.dpi: 96' $HOME/.Xresources
fi
  
  
